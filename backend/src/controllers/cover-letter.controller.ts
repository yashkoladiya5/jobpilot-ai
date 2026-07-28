import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
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
    res.status(400).json({ success: false, message: "resumeId and jobDescription are required", data: null });
    return;
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
