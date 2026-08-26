import prisma from "../../config/prisma";
import { ApiError } from "../../utils/ApiError";
import { generateStructuredResponse } from "./gemini.client";
import { jobAnalysisSchema } from "./schemas/job-analysis.schema";
import { buildJobAnalysisPrompt } from "./prompts/job-analysis.prompt";
import fs from "fs/promises";
import { z } from "zod";

/**
 * Service for analyzing job descriptions using AI to extract key skills and requirements.
 */
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

  async deleteJobAnalysis(analysisId: string, userId: string) {
    const analysis = await prisma.jobAnalysis.findFirst({
      where: { id: analysisId, userId },
    });

    if (!analysis) {
      throw ApiError.notFound("Job analysis not found");
    }

    await prisma.jobAnalysis.delete({
      where: { id: analysisId },
    });
  }

  async generateCoverLetter(userId: string, jobDescription: string, resumeId?: string) {
    let resumeText = "";
    if (resumeId) {
      const resume = await prisma.resume.findFirst({ where: { id: resumeId, userId } });
      if (resume) {
        try {
          resumeText = await fs.readFile(resume.filePath, "utf-8");
        } catch {
          resumeText = `[Binary file - text extraction not supported yet]`;
        }
      }
    }

    const prompt = `Write a professional, compelling, and tailored cover letter for the following job description.\n\nJob Description:\n${jobDescription}\n\n${resumeText ? `Use my resume information below to highlight relevant skills and experience:\n${resumeText}` : 'Highlight general enthusiasm and strong communication skills.'}\n\nKeep it under 400 words, use standard professional formatting, and make it engaging.`;

    const result = await generateStructuredResponse(prompt, z.object({
      coverLetterText: z.string().describe("The full text of the cover letter"),
      suggestedSubjectLine: z.string().describe("A suggested subject line if sending via email"),
      keyPointsHighlighted: z.array(z.string()).describe("Key skills or experiences highlighted in this letter")
    }));

    if (!result.success || !result.data) {
      throw ApiError.internal("Failed to generate cover letter: " + (result.error || "Unknown error"));
    }

    return result.data;
  }

  async detectJobRedFlags(userId: string, jobDescription: string) {
    if (!jobDescription) {
      throw ApiError.badRequest("Job description is required for red flag detection.");
    }

    const prompt = `Analyze the following job description for common "red flags" or toxic traits. Look for phrases like "wear many hats", "fast-paced environment", "work hard play hard", "family", "rockstar", etc.
    
    Job Description:
    ${jobDescription}
    
    Return a structured JSON with:
    - hasRedFlags: boolean
    - redFlags: array of strings containing the exact phrases found and what they typically mean (e.g., "Fast-paced environment: Often means understaffed and high stress.")
    - toxicityScore: number from 0-100 (100 being highly toxic)
    - overallVerdict: string summarizing the assessment
    `;

    const result = await generateStructuredResponse(prompt, z.object({
      hasRedFlags: z.boolean(),
      redFlags: z.array(z.string()),
      toxicityScore: z.number().min(0).max(100),
      overallVerdict: z.string(),
    }));

    if (!result.success || !result.data) {
      throw ApiError.internal("Failed to analyze job description for red flags: " + (result.error || "Unknown error"));
    }

    return {
      userId,
      ...result.data,
      analyzedAt: new Date()
    };
  }
}
