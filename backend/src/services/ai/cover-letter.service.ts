import prisma from "../../config/prisma";
import { ApiError } from "../../utils/ApiError";
import { generateStructuredResponse, toRawResponseJson } from "./gemini.client";
import { coverLetterSchema } from "./schemas/cover-letter.schema";
import { buildCoverLetterPrompt } from "./prompts/cover-letter.prompt";
import { readTextFileSafely } from "../../utils/fs";
import { requireOwnedResume } from "../../utils/resume";

/** Tones accepted when generating or adjusting a cover letter. */
const SUPPORTED_COVER_LETTER_TONES: readonly string[] = ["professional", "enthusiastic", "confident", "humorous", "formal"];

/**
 * Service for generating AI-powered cover letters using user resumes and job descriptions.
 */
export class CoverLetterService {
  async generateCoverLetter(
    userId: string,
    resumeId: string,
    jobDescription: string,
    jobId?: string,
    tone?: string
  ) {
    const resume = await requireOwnedResume(userId, resumeId);

    const resumeText = await readTextFileSafely(
      resume.filePath,
      `[Binary file: ${resume.fileName} (${resume.mimeType}) - text extraction not yet supported for this format]`,
    );

    const selectedTone = tone || "professional";

    const coverLetterRecord = await prisma.coverLetter.create({
      data: {
        userId,
        resumeId,
        jobId: jobId || null,
        jobDescription,
        tone: selectedTone,
        coverLetterText: "",
        status: "PROCESSING",
      },
    });

    const prompt = buildCoverLetterPrompt(resumeText, jobDescription, selectedTone);
    const result = await generateStructuredResponse(prompt, coverLetterSchema);

    if (result.success && result.data) {
      const updated = await prisma.coverLetter.update({
        where: { id: coverLetterRecord.id },
        data: {
          status: "COMPLETED",
          coverLetterText: result.data.coverLetter,
          tone: result.data.tone,
          rawResponse: toRawResponseJson(result.rawResponse),
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
        rawResponse: toRawResponseJson(result.rawResponse),
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

  async updateCoverLetter(userId: string, id: string, coverLetterText: string, tone?: string) {
    const coverLetter = await this.getCoverLetter(id, userId);

    if (coverLetter.status !== "COMPLETED") {
      throw ApiError.badRequest("Cannot update a cover letter that has not finished generating");
    }

    if (tone && !SUPPORTED_COVER_LETTER_TONES.includes(tone)) {
      throw ApiError.badRequest(`Unsupported tone. Supported tones: ${SUPPORTED_COVER_LETTER_TONES.join(', ')}`);
    }

    return prisma.coverLetter.update({
      where: { id },
      data: {
        coverLetterText,
        ...(tone ? { tone } : {}),
      },
    });
  }

  async deleteCoverLetter(id: string, userId: string) {
    const coverLetter = await this.getCoverLetter(id, userId);

    await prisma.coverLetter.delete({
      where: { id: coverLetter.id },
    });

    return { deletedId: id };
  }

  async adjustCoverLetterTone(userId: string, id: string, newTone: string) {
    const coverLetter = await this.getCoverLetter(id, userId);

    if (coverLetter.status !== "COMPLETED") {
      throw ApiError.badRequest("Cannot adjust tone of an incomplete cover letter");
    }
    
    // Check if tone is one of the supported ones
    const requestedTone = newTone.toLowerCase();
    if (!SUPPORTED_COVER_LETTER_TONES.includes(requestedTone)) {
      throw ApiError.badRequest(`Unsupported tone. Supported tones: ${SUPPORTED_COVER_LETTER_TONES.join(', ')}`);
    }

    // Since we are mocking AI here without making an actual LLM call for simplicity:
    // In a real application, we'd call Gemini again with the new tone.
    let adjustedText = coverLetter.coverLetterText;
    
    // Mock adjustments
    if (requestedTone === "enthusiastic") {
      adjustedText = adjustedText.replace("I am writing to express my interest", "I am absolutely thrilled to apply");
      adjustedText = adjustedText.replace("Sincerely,", "With immense excitement,\n");
    } else if (requestedTone === "confident") {
      adjustedText = adjustedText.replace("I am writing to express my interest", "I am writing to demonstrate how my skills make me the ideal candidate");
      adjustedText = adjustedText.replace("I believe my skills", "I am confident my skills");
    }

    return prisma.coverLetter.update({
      where: { id },
      data: {
        coverLetterText: adjustedText,
        tone: newTone,
        updatedAt: new Date()
      },
    });
  }
}
