import prisma from "../../config/prisma";
import { generateStructuredResponse } from "./gemini.client";
import { buildResumeMatchingPrompt } from "./prompts/resume-matching.prompt";
import { resumeMatchingSchema, ResumeMatchingOutput } from "./schemas/resume-matching.schema";
import { ApiError } from "../../utils/ApiError";
import fs from "fs/promises";

export class MatchingService {
  async matchResumeAndJob(
    userId: string,
    resumeId: string,
    jobDescription: string
  ): Promise<{ matchResult: ResumeMatchingOutput; analysisId: string }> {
    const resume = await prisma.resume.findFirst({
      where: { id: resumeId, userId },
    });

    if (!resume) {
      throw ApiError.notFound("Resume not found");
    }

    const resumeText = await fs.readFile(resume.filePath, "utf-8").catch(() => {
      throw ApiError.badRequest("Could not read resume file. Only text-based resumes are supported.");
    });

    const analysis = await prisma.jobAnalysis.create({
      data: {
        userId,
        jobDescription,
        status: "PROCESSING",
      },
    });

    const prompt = buildResumeMatchingPrompt(resumeText, jobDescription);
    const response = await generateStructuredResponse(prompt, resumeMatchingSchema);

    if (!response.success || !response.data) {
      await prisma.jobAnalysis.update({
        where: { id: analysis.id },
        data: { status: "FAILED", errorMessage: response.error || "Analysis failed" },
      });
      throw ApiError.internal(response.error || "Failed to analyze match");
    }

    const updated = await prisma.jobAnalysis.update({
      where: { id: analysis.id },
      data: {
        status: "COMPLETED",
        resumeMatchScore: response.data.matchScore,
        missingSkills: response.data.missingSkills,
        recommendedChanges: response.data.priorityImprovements,
        rawResponse: response.rawResponse ? { text: response.rawResponse } : undefined,
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
}

export const matchingService = new MatchingService();
