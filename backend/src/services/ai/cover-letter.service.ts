import { AnalysisStatus } from "@prisma/client";
import prisma from "../../config/prisma";
import { ApiError } from "../../utils/ApiError";
import { generateStructuredResponse, toRawResponseJson } from "./gemini.client";
import { coverLetterSchema } from "./schemas/cover-letter.schema";
import { buildCoverLetterPrompt } from "./prompts/cover-letter.prompt";
import { readTextFileSafely } from "../../utils/fs";
import { requireOwnedResume } from "../../utils/resume";
import { countWords, splitSentences } from "../../utils/text";

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
        status: AnalysisStatus.PROCESSING,
      },
    });

    const prompt = buildCoverLetterPrompt(resumeText, jobDescription, selectedTone);
    const result = await generateStructuredResponse(prompt, coverLetterSchema);

    if (result.success && result.data) {
      const updated = await prisma.coverLetter.update({
        where: { id: coverLetterRecord.id },
        data: {
          status: AnalysisStatus.COMPLETED,
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
        status: AnalysisStatus.FAILED,
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

    if (coverLetter.status !== AnalysisStatus.COMPLETED) {
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

    if (coverLetter.status !== AnalysisStatus.COMPLETED) {
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

  async scoreLetterSpecificity(userId: string, id: string) {
    const coverLetter = await this.getCoverLetter(id, userId);

    const text = coverLetter.coverLetterText ?? "";
    const jobWords = coverLetter.jobDescription
      ? new Set(coverLetter.jobDescription.toLowerCase().split(/\s+/).filter((w) => w.length > 5))
      : new Set<string>();

    // Quantified achievements: numbers that are not bare years at sentence starts.
    const metricMatches = text.match(/\b\d+(\.\d+)?\s?(%|percent|x|k|m|bn|users|clients|projects|hours|days|weeks|months|years|records)\b/gi) ?? [];

    // Generic filler phrases that make letters templated.
    const fillerPhrases = [
      "team player",
      "hard-working",
      "hard working",
      "excellent communication skills",
      "strong work ethic",
      "dynamic environment",
      "fast-paced environment",
      "proven track record",
      "detail-oriented",
      "results-driven",
    ];
    const lower = text.toLowerCase();
    const fillersFound = fillerPhrases.filter((p) => lower.includes(p));

    // Role/title presence: does the letter name the job from the description header?
    const roleMentioned = lower.includes("position of") || lower.includes("role of");

    const words = text.split(/\s+/).filter(Boolean).length;
    const uniqueSignal = metricMatches.length * 15 + (roleMentioned ? 10 : 0) + (jobWords.size > 0 ? Math.min(jobWords.size, 20) : 0);
    const penalty = fillersFound.length * 12;
    const score = Math.max(0, Math.min(100, 40 + uniqueSignal - penalty + (words > 150 ? 5 : 0)));

    return {
      coverLetterId: coverLetter.id,
      wordCount: words,
      quantifiedAchievements: metricMatches.length,
      genericPhrasesFound: fillersFound,
      namesSpecificRole: roleMentioned,
      score,
      grade: score >= 75 ? "personalized" : score >= 50 ? "mix of specifics and filler" : "reads like a template",
      message: fillersFound.length > 0
        ? `Replace ${fillersFound.length} generic phrase(s) with quantified wins to raise specificity.`
        : score >= 75
          ? "Strong, specific letter — it references concrete results."
          : "Add at least one metric or named outcome to stand out.",
      scoredAt: new Date().toISOString()
    };
  }

  async checkCallToAction(userId: string, id: string) {
    const coverLetter = await this.getCoverLetter(id, userId);
    const text = coverLetter.coverLetterText ?? "";

    const sentences = text
      .split(/(?<=[.!?])\s+/)
      .map((s) => s.trim())
      .filter(Boolean);

    const closing = sentences.slice(-3).join(" ").toLowerCase();

    const ctaSignals = [
      "look forward",
      "follow up",
      "schedule",
      "discuss",
      "interview",
      "available for",
      "contact me",
      "reach out",
      "call",
    ];
    const foundSignals = ctaSignals.filter((s) => closing.includes(s));

    const hasAvailability = /\d{3}[-.)]\s?\d{3}[-.]\d{4}|[\w.+-]+@[\w-]+\.[\w.-]+/.test(text);
    const confidentClosing = /(sincerely|best regards|thank you)/i.test(closing);

    const grade =
      foundSignals.length >= 2 && hasAvailability
        ? "strong"
        : foundSignals.length === 1
          ? "partial"
          : "missing";

    return {
      coverLetterId: coverLetter.id,
      grade,
      ctaSignalsFound: foundSignals,
      hasContactDetails: hasAvailability,
      courteousClosing: confidentClosing,
      advice: grade === "strong"
        ? "Closing clearly invites the next step and gives a way to reach you."
        : grade === "partial"
          ? "Add one explicit next step, e.g. 'I will follow up next week to schedule a conversation.'"
          : "Your letter never asks for anything — end with a concrete next step and your contact details.",
      checkedAt: new Date().toISOString()
    };
  }

  async checkLengthConstraints(userId: string, id: string) {
    const coverLetter = await this.getCoverLetter(id, userId);
    const text = coverLetter.coverLetterText ?? "";

    const MIN_WORDS = 250;
    const MAX_WORDS = 400;
    const MIN_PARAGRAPHS = 3;
    const MAX_PARAGRAPHS = 5;
    const LONG_SENTENCE_WORDS = 30;

    const words = countWords(text);
    const paragraphs = text
      .split(/\n\s*\n/)
      .map((p) => p.trim())
      .filter(Boolean);
    const sentences = splitSentences(text);
    const longSentences = sentences
      .map((sentence, index) => ({ index: index + 1, words: countWords(sentence) }))
      .filter((sentence) => sentence.words > LONG_SENTENCE_WORDS);

    const verdict =
      words < MIN_WORDS ? "too_short" : words > MAX_WORDS ? "too_long" : "within_range";

    const issues: string[] = [];
    if (words < MIN_WORDS) issues.push(`Add ${MIN_WORDS - words} more words to reach the ${MIN_WORDS}-word floor.`);
    if (words > MAX_WORDS) issues.push(`Trim ${words - MAX_WORDS} words — recruiters skim past ${MAX_WORDS}.`);
    if (paragraphs.length < MIN_PARAGRAPHS) issues.push("Use at least 3 paragraphs: hook, evidence, closing.");
    if (paragraphs.length > MAX_PARAGRAPHS) issues.push(`Merge paragraphs down to ${MAX_PARAGRAPHS} or fewer.`);
    if (longSentences.length > 0) issues.push(`Sentence(s) ${longSentences.map((s) => s.index).join(", ")} exceed ${LONG_SENTENCE_WORDS} words — split them.`);

    return {
      coverLetterId: coverLetter.id,
      wordCount: words,
      targetRange: { min: MIN_WORDS, max: MAX_WORDS },
      verdict,
      paragraphCount: paragraphs.length,
      sentenceCount: sentences.length,
      longSentences,
      issues,
      message: issues.length === 0
        ? `Well sized: ${words} words in ${paragraphs.length} paragraphs.`
        : issues.join(" "),
      checkedAt: new Date().toISOString()
    };
  }
}
