import { AnalysisStatus } from "@prisma/client";
import prisma from "../../config/prisma";
import { generateStructuredResponse, toRawResponseJson } from "./gemini.client";
import { buildResumeMatchingPrompt } from "./prompts/resume-matching.prompt";
import { resumeMatchingSchema, ResumeMatchingOutput } from "./schemas/resume-matching.schema";
import { ApiError } from "../../utils/ApiError";
import { requireOwnedResume } from "../../utils/resume";
import { readTextFileOrThrow } from "../../utils/fs";

/**
 * Service that uses AI to score and match user resumes against specific job descriptions.
 */
export class MatchingService {
  async matchResumeAndJob(
    userId: string,
    resumeId: string,
    jobDescription: string
  ): Promise<{ matchResult: ResumeMatchingOutput; analysisId: string }> {
    const resume = await requireOwnedResume(userId, resumeId);

    const resumeText = await readTextFileOrThrow(
      resume.filePath,
      "Could not read resume file. Only text-based resumes are supported.",
    );

    const analysis = await prisma.jobAnalysis.create({
      data: {
        userId,
        jobDescription,
        status: AnalysisStatus.PROCESSING,
      },
    });

    const prompt = buildResumeMatchingPrompt(resumeText, jobDescription);
    const response = await generateStructuredResponse(prompt, resumeMatchingSchema);

    if (!response.success || !response.data) {
      await prisma.jobAnalysis.update({
        where: { id: analysis.id },
        data: { status: AnalysisStatus.FAILED, errorMessage: response.error || "Analysis failed" },
      });
      throw ApiError.internal(response.error || "Failed to analyze match");
    }

    await prisma.jobAnalysis.update({
      where: { id: analysis.id },
      data: {
        status: AnalysisStatus.COMPLETED,
        resumeMatchScore: response.data.matchScore,
        missingSkills: response.data.missingSkills,
        recommendedChanges: response.data.priorityImprovements,
        rawResponse: toRawResponseJson(response.rawResponse),
        analyzedAt: new Date(),
      },
    });

    return { matchResult: response.data, analysisId: analysis.id };
  }

  async getMatchResult(analysisId: string, userId: string) {
    const analysis = await prisma.jobAnalysis.findFirst({
      where: { id: analysisId, userId },
    });
    if (!analysis) throw ApiError.notFound("Match analysis not found");
    return analysis;
  }

  async getTopMatchesForResume(resumeId: string, userId: string, limit: number = 5) {
    await requireOwnedResume(userId, resumeId);

    return prisma.jobAnalysis.findMany({
      where: { userId, resumeMatchScore: { not: null } },
      orderBy: { resumeMatchScore: "desc" },
      take: limit,
      include: { job: { select: { companyName: true, role: true } } },
    });
  }

  async getMatchDetails(analysisId: string, userId: string) {
    const analysis = await prisma.jobAnalysis.findFirst({
      where: { id: analysisId, userId },
      include: {
        job: true,
      }
    });

    if (!analysis) {
      throw ApiError.notFound("Match analysis not found");
    }

    if (analysis.resumeMatchScore === null) {
      throw ApiError.badRequest("This analysis does not have a match score computed yet.");
    }

    return {
      score: analysis.resumeMatchScore,
      missingSkills: analysis.missingSkills || [],
      recommendedChanges: analysis.recommendedChanges || [],
      jobRole: analysis.job?.role || "Unknown",
      company: analysis.job?.companyName || "Unknown",
      analyzedAt: analysis.analyzedAt,
    };
  }

  async getRecentMatches(userId: string, limit: number = 5) {
    const recentMatches = await prisma.jobAnalysis.findMany({
      where: { 
        userId, 
        resumeMatchScore: { not: null },
        status: AnalysisStatus.COMPLETED
      },
      orderBy: { analyzedAt: "desc" },
      take: limit,
      include: {
        job: { select: { companyName: true, role: true, location: true } },
      }
    });

    return recentMatches.map(match => ({
      id: match.id,
      score: match.resumeMatchScore,
      jobRole: match.job?.role || "Unknown",
      company: match.job?.companyName || "Unknown",
      location: match.job?.location || "Unknown",
      analyzedAt: match.analyzedAt,
      priorityImprovementsCount: Array.isArray(match.recommendedChanges)
        ? match.recommendedChanges.length
        : 0
    }));
  }

  async predictWorkStyleFit(userId: string, resumeId: string, companyValuesText: string) {
    await requireOwnedResume(userId, resumeId);

    if (!companyValuesText || companyValuesText.trim().length === 0) {
      throw ApiError.badRequest("companyValuesText is required for work-style fit.");
    }

    const resume = await prisma.resume.findUnique({ where: { id: resumeId } });
    const resumeText = await readTextFileOrThrow(resume!.filePath, "Resume file could not be read.");

    const resumeLower = resumeText.toLowerCase();
    const valuesLower = companyValuesText.toLowerCase();

    const dimensions: { name: string; signals: string[] }[] = [
      { name: "autonomy", signals: ["independent", "self-directed", "ownership", "solo", "自主"] },
      { name: "collaboration", signals: ["team", "collaborat", "cross-functional", "pair"] },
      { name: "mentorship", signals: ["mentor", "coach", "taught", "training", "onboarded"] },
      { name: "speed", signals: ["fast-paced", "agile", "ship", "deadline", "startup"] },
      { name: "depth", signals: ["research", "deep dive", "architect", "patent", "publication"] },
      { name: "remote-first", signals: ["remote", "distributed", "async", "timezone"] },
    ];

    const scores = dimensions.map((dim) => {
      const inResume = dim.signals.filter((s) => resumeLower.includes(s)).length;
      const inValues = dim.signals.filter((s) => valuesLower.includes(s)).length;
      // Fit: both sides mention the dimension; gap: only one side does.
      let verdict: "aligned" | "unknown" | "gap";
      if (inResume > 0 && inValues > 0) verdict = "aligned";
      else if (inResume === 0 && inValues > 0) verdict = "gap";
      else verdict = "unknown";
      return { dimension: dim.name, resumeSignals: inResume, valuesSignals: inValues, verdict };
    });

    const aligned = scores.filter((s) => s.verdict === "aligned").length;
    const gaps = scores.filter((s) => s.verdict === "gap");
    const fitPercent = Math.round((aligned / dimensions.length) * 100);

    return {
      resumeId,
      fitPercent,
      alignedDimensions: aligned,
      scores,
      message: gaps.length === 0
        ? `Strong work-style overlap — ${aligned}/${dimensions.length} dimensions align.`
        : `Company emphasizes ${gaps.map((g) => g.dimension).join(", ")} which your resume does not evidence yet.`,
      predictedAt: new Date().toISOString()
    };
  }
}

export const matchingService = new MatchingService();
