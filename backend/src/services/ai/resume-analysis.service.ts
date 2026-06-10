import prisma from "../../config/prisma";
import { ApiError } from "../../utils/ApiError";
import { generateStructuredResponse } from "./gemini.client";
import { resumeAnalysisSchema } from "./schemas/resume-analysis.schema";
import { buildResumeAnalysisPrompt } from "./prompts/resume-analysis.prompt";
import fs from "fs/promises";

export class ResumeAnalysisService {
  async analyzeResume(userId: string, resumeId: string) {
    const resume = await prisma.resume.findFirst({
      where: { id: resumeId, userId },
    });

    if (!resume) {
      throw ApiError.notFound("Resume not found");
    }

    let resumeText: string;
    try {
      resumeText = await fs.readFile(resume.filePath, "utf-8");
    } catch {
      resumeText = `[Binary file: ${resume.fileName} (${resume.mimeType}) - text extraction not yet supported for this format]`;
    }

    const analysis = await prisma.resumeAnalysis.create({
      data: {
        resumeId,
        userId,
        status: "PROCESSING",
      },
    });

    const prompt = buildResumeAnalysisPrompt(resumeText);
    const result = await generateStructuredResponse(prompt, resumeAnalysisSchema);

    if (result.success && result.data) {
      const updated = await prisma.resumeAnalysis.update({
        where: { id: analysis.id },
        data: {
          status: "COMPLETED",
          atsScore: result.data.atsScore,
          strengths: result.data.strengths,
          weaknesses: result.data.weaknesses,
          missingKeywords: result.data.missingKeywords,
          suggestions: result.data.suggestions,
          experienceSummary: result.data.experienceSummary,
          skillsSummary: result.data.skillsSummary,
          recruiterFeedback: result.data.recruiterFeedback,
          rawResponse: result.rawResponse ? { text: result.rawResponse } : undefined,
          analyzedAt: new Date(),
        },
      });
      return updated;
    }

    const failed = await prisma.resumeAnalysis.update({
      where: { id: analysis.id },
      data: {
        status: "FAILED",
        errorMessage: result.error || "Analysis failed",
        rawResponse: result.rawResponse ? { text: result.rawResponse } : undefined,
      },
    });
    return failed;
  }

  async getAnalysisByResume(resumeId: string, userId: string) {
    const resume = await prisma.resume.findFirst({
      where: { id: resumeId, userId },
    });

    if (!resume) {
      throw ApiError.notFound("Resume not found");
    }

    const analysis = await prisma.resumeAnalysis.findFirst({
      where: { resumeId },
      orderBy: { createdAt: "desc" },
    });

    if (!analysis) {
      throw ApiError.notFound("No analysis found for this resume");
    }

    return analysis;
  }

  async getUserAnalyses(userId: string) {
    return prisma.resumeAnalysis.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      include: {
        resume: {
          select: { id: true, fileName: true },
        },
      },
    });
  }
}
