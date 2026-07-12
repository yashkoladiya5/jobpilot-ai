import prisma from "../../config/prisma";
import { ApiError } from "../../utils/ApiError";
import { generateStructuredResponse } from "./gemini.client";
import { coverLetterSchema } from "./schemas/cover-letter.schema";
import { buildCoverLetterPrompt } from "./prompts/cover-letter.prompt";
import fs from "fs/promises";

export class CoverLetterService {
  async generateCoverLetter(
    userId: string,
    resumeId: string,
    jobDescription: string,
    jobId?: string,
    tone?: string
  ) {
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

    const coverLetterRecord = await prisma.coverLetter.create({
      data: {
        userId,
        resumeId,
        jobId: jobId || null,
        jobDescription,
        tone: tone || "professional",
        coverLetterText: "",
        status: "PROCESSING",
      },
    });

    const selectedTone = tone || "professional";
    const prompt = buildCoverLetterPrompt(resumeText, jobDescription, selectedTone);
    const result = await generateStructuredResponse(prompt, coverLetterSchema);

    if (result.success && result.data) {
      const updated = await prisma.coverLetter.update({
        where: { id: coverLetterRecord.id },
        data: {
          status: "COMPLETED",
          coverLetterText: result.data.coverLetter,
          tone: result.data.tone,
          rawResponse: result.rawResponse ? { text: result.rawResponse } : undefined,
          generatedAt: new Date(),
        },
      });
      return updated;
    }

    const failed = await prisma.coverLetter.update({
      where: { id: coverLetterRecord.id },
      data: {
        status: "FAILED",
        errorMessage: result.error || "Cover letter generation failed",
        rawResponse: result.rawResponse ? { text: result.rawResponse } : undefined,
      },
    });
    return failed;
  }

  async getCoverLetter(id: string, userId: string) {
    const coverLetter = await prisma.coverLetter.findFirst({
      where: { id, userId },
    });

    if (!coverLetter) {
      throw ApiError.notFound("Cover letter not found");
    }

    return coverLetter;
  }

  async getUserCoverLetters(userId: string) {
    return prisma.coverLetter.findMany({
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
