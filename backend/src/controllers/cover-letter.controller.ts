import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { ApiError } from "../utils/ApiError";
import { CoverLetterService } from "../services/ai/cover-letter.service";

/**
 * Controller for Cover Letter operations.
 * Handles generation and retrieval of AI cover letters.
 */
const coverLetterService = new CoverLetterService();

export const generateCoverLetter = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId, jobDescription, jobId, tone } = req.body;
  if (!resumeId || !jobDescription) {
    throw ApiError.badRequest("resumeId and jobDescription are required");
  }
  const result = await coverLetterService.generateCoverLetter(userId, resumeId, jobDescription, jobId, tone);
  res.status(200).json({
    success: true,
    message: "Cover letter generated successfully",
    data: result,
  });
});

export const getCoverLetter = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  const result = await coverLetterService.getCoverLetter(id, userId);
  res.status(200).json({
    success: true,
    message: "Cover letter fetched successfully",
    data: result,
  });
});

export const getCoverLetters = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await coverLetterService.getUserCoverLetters(userId);
  res.status(200).json({
    success: true,
    message: "Cover letters fetched successfully",
    data: result,
  });
});

export const updateCoverLetter = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  const { coverLetterText, tone } = req.body;
  
  if (!coverLetterText) {
    throw ApiError.badRequest("Cover letter text is required for update");
  }

  const result = await coverLetterService.updateCoverLetter(userId, id, coverLetterText, tone);
  
  res.status(200).json({
    success: true,
    message: "Cover letter manually updated successfully",
    data: result,
  });
});

export const deleteCoverLetter = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  
  await coverLetterService.deleteCoverLetter(id, userId);
  
  res.status(200).json({
    success: true,
    message: "Cover letter deleted successfully",
    data: null,
  });
});

export const adjustTone = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  const { tone } = req.body;
  
  if (!tone) {
    throw ApiError.badRequest("Tone is required for adjustment");
  }

  const result = await coverLetterService.adjustCoverLetterTone(userId, id, tone);
  
  res.status(200).json({
    success: true,
    message: `Cover letter tone adjusted to ${tone} successfully`,
    data: result,
  });
});
