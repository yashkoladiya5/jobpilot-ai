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

export const getPrimaryResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  
  const resume = await resumeService.getPrimaryResume(userId);
  
  res.status(200).json({
    success: true,
    message: "Primary resume fetched successfully",
    data: resume,
  });
});

export const duplicateResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  
  const duplicatedResume = await resumeService.duplicateResume(userId, id);
  
  res.status(201).json({
    success: true,
    message: "Resume duplicated successfully",
    data: duplicatedResume,
  });
});

export const getResumeStats = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  
  const stats = await resumeService.getResumeStats(userId);
  
  res.status(200).json({
    success: true,
    message: "Resume statistics fetched successfully",
    data: stats,
  });
});

export const getRecentResumeActivity = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  
  const activity = await resumeService.getRecentResumeActivity(userId);
  
  res.status(200).json({
    success: true,
    message: "Recent resume activity fetched successfully",
    data: activity,
  });
});

export const getResumeVersionHistory = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  
  const history = await resumeService.getResumeVersionHistory(userId, id);
  
  res.status(200).json({
    success: true,
    message: "Resume version history fetched successfully",
    data: history,
  });
});

export const getResumeQualityScore = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  
  const scoreData = await resumeService.getResumeQualityScore(userId, id);
  
  res.status(200).json({
    success: true,
    message: "Resume quality score generated successfully",
    data: scoreData,
  });
});

export const getAtsOptimizedText = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  
  const atsData = await resumeService.getAtsOptimizedText(userId, id);
  
  res.status(200).json({
    success: true,
    message: "ATS optimized text generated successfully",
    data: atsData,
  });
});

export const analyzeMissingKeywords = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const { jobDescription } = req.body;
  
  const analysis = await resumeService.analyzeMissingKeywords(userId, id, jobDescription);
  
  res.status(200).json({
    success: true,
    message: "Missing keywords analyzed successfully",
    data: analysis,
  });
});

export const translateResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const { targetLanguage } = req.body;
  
  const translation = await resumeService.translateResume(userId, id, targetLanguage);
  
  res.status(200).json({
    success: true,
    message: `Resume translated to ${targetLanguage} successfully`,
    data: translation,
  });
});

export const trackResumeView = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const { source } = req.body;
  
  const viewLog = await resumeService.trackResumeView(userId, id, source);
  
  res.status(200).json({
    success: true,
    message: "Resume view tracked successfully",
    data: viewLog,
  });
});

export const generateShareableLink = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const { expiresInDays } = req.body;
  
  const result = await resumeService.generateShareableLink(userId, id, expiresInDays);
  
  res.status(200).json({
    success: true,
    message: "Shareable link generated successfully",
    data: result,
  });
});

export const generateResumeSummary = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  
  const summaryData = await resumeService.generateResumeSummary(userId, id);
  
  res.status(200).json({
    success: true,
    message: "Resume summary generated successfully",
    data: summaryData,
  });
});

export const exportResumeAsJson = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  
  const jsonData = await resumeService.exportResumeAsJson(userId, id);
  
  res.status(200).json({
    success: true,
    message: "Resume exported as JSON successfully",
    data: jsonData,
  });
});

export const cloneResume = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  
  const clonedResume = await resumeService.cloneResume(userId, id);
  
  res.status(201).json({
    success: true,
    message: "Resume cloned successfully",
    data: clonedResume,
  });
});

export const generateJobTitleMatchReport = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const { jobTitle } = req.body;
  
  const report = await resumeService.generateJobTitleMatchReport(userId, id, jobTitle);
  
  res.status(200).json({
    success: true,
    message: "Job title match report generated successfully",
    data: report,
  });
});

export const exportResumeAsPdf = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  
  const pdfData = await resumeService.exportResumeAsPdf(userId, id);
  
  res.status(200).json({
    success: true,
    message: "Resume exported as PDF successfully",
    data: pdfData,
  });
});

export const generateResumeVariations = asyncHandler(async (req: Request, res: Response) => {
  const { id: userId } = (req as AuthenticatedRequest).user;
  const { id } = req.params;
  const { variationType } = req.body;
  
  const variedResume = await resumeService.generateResumeVariations(userId, id, variationType);
  
  res.status(201).json({
    success: true,
    message: `Resume variation '${variationType}' generated successfully`,
    data: variedResume,
  });
});
