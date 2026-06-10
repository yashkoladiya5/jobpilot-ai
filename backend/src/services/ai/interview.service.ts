import prisma from "../../config/prisma";
import { generateStructuredResponse } from "./gemini.client";
import { buildInterviewQuestionsPrompt } from "./prompts/interview.prompt";
import { interviewQuestionsSchema, InterviewQuestionsOutput } from "./schemas/interview.schema";
import { ApiError } from "../../utils/ApiError";
import fs from "fs/promises";
import { z } from "zod";

export class InterviewService {
  async generateQuestions(userId: string, jobId: string) {
    const job = await prisma.jobApplication.findFirst({
      where: { id: jobId, userId },
      include: { resume: true },
    });

    if (!job) throw ApiError.notFound("Job not found");

    let resumeText: string | undefined;
    if (job.resume) {
      resumeText = await fs.readFile(job.resume.filePath, "utf-8").catch(() => undefined);
    }

    const session = await prisma.interviewSession.create({
      data: {
        userId,
        jobId,
        status: "PROCESSING",
        jobDescription: job.notes || "",
      },
    });

    const prompt = buildInterviewQuestionsPrompt(
      `${job.role} at ${job.companyName}\n\nDescription: ${job.notes || "No description provided."}\n\nLocation: ${job.location || "Remote"}\nSalary: ${job.salaryRange || "Not specified"}`,
      resumeText
    );

    const response = await generateStructuredResponse(prompt, interviewQuestionsSchema);

    if (!response.success || !response.data) {
      await prisma.interviewSession.update({
        where: { id: session.id },
        data: { status: "FAILED" },
      });
      throw ApiError.internal(response.error || "Failed to generate questions");
    }

    const allQuestions = [
      ...response.data.hrQuestions.map((q, i) => ({ ...q, orderIndex: i })),
      ...response.data.technicalQuestions.map((q, i) => ({ ...q, orderIndex: i + 5 })),
      ...response.data.behavioralQuestions.map((q, i) => ({ ...q, orderIndex: i + 10 })),
      ...response.data.followUpQuestions.map((q, i) => ({ ...q, orderIndex: i + 15 })),
    ];

    const totalQuestions = allQuestions.length;

    await prisma.interviewSession.update({
      where: { id: session.id },
      data: {
        status: "COMPLETED",
        hrQuestions: response.data.hrQuestions as any,
        technicalQuestions: response.data.technicalQuestions as any,
        behavioralQuestions: response.data.behavioralQuestions as any,
        followUpQuestions: response.data.followUpQuestions as any,
        totalQuestions,
        rawResponse: response.rawResponse ? { text: response.rawResponse } : undefined,
      },
    });

    for (const q of allQuestions) {
      await prisma.interviewQuestion.create({
        data: {
          sessionId: session.id,
          category: q.category,
          question: q.question,
          orderIndex: q.orderIndex,
        },
      });
    }

    return prisma.interviewSession.findUnique({
      where: { id: session.id },
      include: { questions: { orderBy: { orderIndex: "asc" } } },
    });
  }

  async getSessions(userId: string) {
    return prisma.interviewSession.findMany({
      where: { userId },
      include: {
        job: { select: { id: true, companyName: true, role: true } },
        _count: { select: { questions: true } },
      },
      orderBy: { createdAt: "desc" },
    });
  }

  async getSession(sessionId: string, userId: string) {
    const session = await prisma.interviewSession.findFirst({
      where: { id: sessionId, userId },
      include: { questions: { orderBy: { orderIndex: "asc" } } },
    });
    if (!session) throw ApiError.notFound("Interview session not found");
    return session;
  }

  async submitAnswer(questionId: string, answer: string, userId: string) {
    const question = await prisma.interviewQuestion.findUnique({
      where: { id: questionId },
      include: { session: true },
    });

    if (!question || question.session.userId !== userId) {
      throw ApiError.notFound("Question not found");
    }

    const session = question.session;

    const score = answer.length > 50 ? 8 : answer.length > 20 ? 6 : 4;

    await prisma.interviewQuestion.update({
      where: { id: questionId },
      data: {
        answer,
        score,
        answeredAt: new Date(),
      },
    });

    const answeredCount = await prisma.interviewQuestion.count({
      where: { sessionId: session.id, answeredAt: { not: null } },
    });

    await prisma.interviewSession.update({
      where: { id: session.id },
      data: {
        answeredQuestions: answeredCount,
        currentQuestionIndex: question.orderIndex + 1,
      },
    });

    let feedback = "Good answer. Consider providing more specific examples from your experience.";

    try {
      const feedbackSchema = z.object({
        feedback: z.string(),
        score: z.number().min(0).max(10),
        improvementTip: z.string(),
      });
      const feedbackResult = await generateStructuredResponse(
        `Evaluate this interview answer:\n\nQuestion: ${question.question}\n\nAnswer: ${answer}\n\nProvide structured feedback.`,
        feedbackSchema
      );
      if (feedbackResult.success && feedbackResult.data) {
        feedback = feedbackResult.data.feedback;
        await prisma.interviewQuestion.update({
          where: { id: questionId },
          data: { feedback, score: feedbackResult.data.score },
        });
      }
    } catch {
      // Use default feedback
    }

    return { feedback, score, answeredCount, totalQuestions: session.totalQuestions };
  }

  async completeSession(sessionId: string, userId: string) {
    const session = await prisma.interviewSession.findFirst({
      where: { id: sessionId, userId },
      include: { questions: true },
    });

    if (!session) throw ApiError.notFound("Interview session not found");

    const answered = session.questions.filter(q => q.answeredAt);
    const totalScore = answered.reduce((sum, q) => sum + (q.score || 0), 0);
    const overallScore = answered.length > 0 ? Math.round((totalScore / answered.length) * 10) : 0;

    const categoryScores: Record<string, number> = {};
    for (const category of ["HR", "TECHNICAL", "BEHAVIORAL", "FOLLOW_UP"]) {
      const catQuestions = session.questions.filter(q => q.category === category);
      const catAnswered = catQuestions.filter(q => q.answeredAt);
      if (catAnswered.length > 0) {
        const catTotal = catAnswered.reduce((sum, q) => sum + (q.score || 0), 0);
        categoryScores[category.toLowerCase()] = Math.round((catTotal / catAnswered.length) * 10);
      }
    }

    const result = await prisma.interviewResult.create({
      data: {
        sessionId,
        overallScore,
        categoryScores: categoryScores as any,
        strengths: answered.filter(q => (q.score || 0) >= 7).map(q => q.question.substring(0, 100)),
        improvements: answered.filter(q => (q.score || 0) < 5).map(q => q.question.substring(0, 100)),
        summary: `Completed ${answered.length}/${session.totalQuestions} questions. Overall score: ${overallScore}/100.`,
      },
    });

    await prisma.interviewSession.update({
      where: { id: sessionId },
      data: {
        status: "COMPLETED",
        score: overallScore,
        completedAt: new Date(),
      },
    });

    return result;
  }

  async getResult(sessionId: string, userId: string) {
    const session = await prisma.interviewSession.findFirst({
      where: { id: sessionId, userId },
    });
    if (!session) throw ApiError.notFound("Interview session not found");

    const result = await prisma.interviewResult.findFirst({
      where: { sessionId },
    });
    if (!result) throw ApiError.notFound("Interview result not found");
    return result;
  }
}

export const interviewService = new InterviewService();
