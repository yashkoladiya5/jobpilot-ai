import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { JobService } from "../services/job.service";

const jobService = new JobService();

export const getJobs = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const jobs = await jobService.getJobs(userId);

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

export const createJob = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
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
