import prisma from "../../config/prisma";
import { ApiError } from "../../utils/ApiError";
import { generateStructuredResponse } from "./gemini.client";
import { jobAnalysisSchema } from "./schemas/job-analysis.schema";
import { buildJobAnalysisPrompt } from "./prompts/job-analysis.prompt";
import fs from "fs/promises";

export class JobAnalysisService {
  async analyzeJobDescription(userId: string, jobDescription: string, jobId?: string) {
    let resumeText: string | undefined;

    if (jobId) {
      const job = await prisma.jobApplication.findFirst({
        where: { id: jobId, userId },
        include: { resume: true },
      });

      if (!job) {
        throw ApiError.notFound("Job application not found");
      }

      if (job.resume) {
        try {
          resumeText = await fs.readFile(job.resume.filePath, "utf-8");
        } catch {
          resumeText = `[Binary file: ${job.resume.fileName} - text extraction not yet supported]`;
        }
      }
    }

    const analysis = await prisma.jobAnalysis.create({
      data: {
        jobId: jobId ?? null,
        userId,
        jobDescription,
        status: "PROCESSING",
      },
    });

    const prompt = buildJobAnalysisPrompt(jobDescription, resumeText);
    const result = await generateStructuredResponse(prompt, jobAnalysisSchema);

    if (result.success && result.data) {
      const updated = await prisma.jobAnalysis.update({
        where: { id: analysis.id },
        data: {
          status: "COMPLETED",
          requiredSkills: result.data.requiredSkills,
          preferredSkills: result.data.preferredSkills,
          experienceRequired: result.data.experienceRequired,
          missingSkills: result.data.missingSkills,
          resumeMatchScore: result.data.resumeMatchScore,
          recommendedChanges: result.data.recommendedChanges,
          rawResponse: result.rawResponse ? { text: result.rawResponse } : undefined,
          analyzedAt: new Date(),
        },
      });
      return updated;
    }

    const failed = await prisma.jobAnalysis.update({
      where: { id: analysis.id },
      data: {
        status: "FAILED",
        errorMessage: result.error || "Job analysis failed",
        rawResponse: result.rawResponse ? { text: result.rawResponse } : undefined,
      },
    });
    return failed;
  }

  async getAnalysisById(analysisId: string, userId: string) {
    const analysis = await prisma.jobAnalysis.findFirst({
      where: { id: analysisId, userId },
    });

    if (!analysis) {
      throw ApiError.notFound("Job analysis not found");
    }

    return analysis;
  }

  async getUserAnalyses(userId: string) {
    return prisma.jobAnalysis.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      include: {
        job: {
          select: { id: true, companyName: true, role: true },
        },
      },
    });
  }
}
