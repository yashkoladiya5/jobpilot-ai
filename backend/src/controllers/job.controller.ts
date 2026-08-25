import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { JobService } from "../services/job.service";

const jobService = new JobService();

export const getJobs = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { search, status, sortBy, sortOrder } = req.query;
  const jobs = await jobService.getJobs(userId, {
    search: search as string | undefined,
    status: status as string | undefined,
    sortBy: sortBy as string | undefined,
    sortOrder: sortOrder as string | undefined,
  });
  res.status(200).json({
    success: true,
    message: "Job applications fetched successfully",
    data: jobs,
  });
});

export const getJobById = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  const job = await jobService.getJobById(userId, id);

  res.status(200).json({
    success: true,
    message: "Job application fetched successfully",
    data: job,
  });
});

export const updateJobStatus = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  const { status } = req.body;
  
  if (!status) {
     res.status(400).json({ success: false, message: "Status is required." });
     return;
  }
  
  const job = await jobService.updateJobStatus(userId, id, status);

  res.status(200).json({
    success: true,
    message: "Job status updated successfully",
    data: job,
  });
});

export const updateJobNote = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  const { notes } = req.body;
  
  if (notes === undefined) {
     res.status(400).json({ success: false, message: "Notes content is required." });
     return;
  }
  
  const job = await jobService.updateJobNote(userId, id, notes);

  res.status(200).json({
    success: true,
    message: "Job note updated successfully",
    data: job,
  });
});

export const archiveJob = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  
  console.log(`[Job Controller] Archiving job ${id} for user ${userId}`);
  const job = await jobService.archiveJob(userId, id);

  res.status(200).json({
    success: true,
    message: "Job application archived successfully",
    data: job,
  });
});

export const bulkUpdateStatus = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobIds, status } = req.body;
  
  if (!status) {
     res.status(400).json({ success: false, message: "Status is required for bulk update." });
     return;
  }
  
  const result = await jobService.bulkUpdateJobStatus(userId, jobIds, status);

  res.status(200).json({
    success: true,
    message: `${result.count} job(s) updated successfully to ${status}`,
    data: result,
  });
});

export const bulkDeleteJobs = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobIds } = req.body;
  
  if (!jobIds || !Array.isArray(jobIds)) {
     res.status(400).json({ success: false, message: "A valid array of job IDs is required." });
     return;
  }
  
  const result = await jobService.bulkDeleteJobs(userId, jobIds);

  res.status(200).json({
    success: true,
    message: `${result.count} job(s) permanently deleted`,
    data: result,
  });
});

export const createJob = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { companyName, role } = req.body;
  
  if (!companyName || companyName.trim() === "") {
     res.status(400).json({ success: false, message: "Company name is required." });
     return;
  }
  
  if (!role || role.trim() === "") {
     res.status(400).json({ success: false, message: "Role is required." });
     return;
  }

  const job = await jobService.createJob(userId, req.body);

  res.status(201).json({
    success: true,
    message: "Job application created successfully",
    data: job,
  });
});

export const updateJob = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  const job = await jobService.updateJob(userId, id, req.body);

  res.status(200).json({
    success: true,
    message: "Job application updated successfully",
    data: job,
  });
});

export const deleteJob = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { id } = req.params;
  await jobService.deleteJob(userId, id);

  res.status(200).json({
    success: true,
    message: "Job application deleted successfully",
    data: null,
  });
});

export const getJobsAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const analytics = await jobService.getJobsAnalytics(userId);

  res.status(200).json({
    success: true,
    message: "Job analytics fetched successfully",
    data: analytics,
  });
});

export const getJobsNeedingFollowUp = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const jobs = await jobService.getJobsNeedingFollowUp(userId);

  res.status(200).json({
    success: true,
    message: "Stale jobs needing follow-up fetched successfully",
    data: jobs,
  });
});

export const getJobNotesSummary = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const summary = await jobService.getJobNotesSummary(userId);

  res.status(200).json({
    success: true,
    message: "Job notes summary fetched successfully",
    data: summary,
  });
});

export const getJobActionItems = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const actionItems = await jobService.getJobActionItems(userId);

  res.status(200).json({
    success: true,
    message: "Job action items generated successfully",
    data: actionItems,
  });
});

export const getJobApplicationVelocity = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const velocity = await jobService.getJobApplicationVelocity(userId);

  res.status(200).json({
    success: true,
    message: "Job application velocity calculated successfully",
    data: velocity,
  });
});
