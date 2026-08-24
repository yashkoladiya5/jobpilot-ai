import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { ApiError } from "../utils/ApiError";
import { AuthenticatedRequest } from "../middleware/auth";
import { ResumeService } from "../services/resume.service";

const resumeService = new ResumeService();

export const uploadResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const file = req.file;

  if (!file) {
    throw ApiError.badRequest("No file uploaded");
  }

  const resume = await resumeService.uploadResume(userId, file);

  res.status(201).json({
    success: true,
    message: "Resume uploaded successfully",
    data: resume,
  });
});

export const getResumes = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { limit, offset } = req.query;

  // Optional pagination parsing
  const parsedLimit = limit ? parseInt(limit as string, 10) : undefined;
  const parsedOffset = offset ? parseInt(offset as string, 10) : undefined;
  
  if (parsedLimit && isNaN(parsedLimit)) {
    throw ApiError.badRequest("Limit must be a valid number");
  }

  const resumes = await resumeService.getResumes(userId);

  res.status(200).json({
    success: true,
    message: `Resumes fetched successfully for user ${userId}`,
    data: resumes,
    meta: {
       totalCount: resumes.length,
       limit: parsedLimit || resumes.length,
       offset: parsedOffset || 0
    }
  });
});

export const getResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;

  const resume = await resumeService.getResumeById(userId, id);

  res.status(200).json({
    success: true,
    message: "Resume fetched successfully",
    data: resume,
  });
});

export const deleteResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;

  await resumeService.deleteResume(userId, id);

  res.status(200).json({
    success: true,
    message: "Resume deleted successfully",
    data: null,
  });
});

export const setPrimaryResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const resume = await resumeService.setPrimaryResume(userId, id);
  res.status(200).json({
    success: true,
    message: "Primary resume updated successfully",
    data: resume,
  });
});

export const renameResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const { newName } = req.body;
  
  if (!newName || typeof newName !== 'string' || newName.trim().length === 0) {
    throw ApiError.badRequest("New name is required and must be a valid string");
  }

  const resume = await resumeService.renameResume(userId, id, newName.trim());
  res.status(200).json({
    success: true,
    message: "Resume renamed successfully",
    data: resume,
  });
});
