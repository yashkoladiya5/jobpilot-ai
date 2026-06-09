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

  const resumes = await resumeService.getResumes(userId);

  res.status(200).json({
    success: true,
    message: "Resumes fetched successfully",
    data: resumes,
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
