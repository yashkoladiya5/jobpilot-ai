import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { AnalyticsService } from "../services/analytics.service";

/**
 * Controller for Analytics Operations.
 * Exposes methods to retrieve pipeline metrics and historical timelines.
 */
const analyticsService = new AnalyticsService();

export const getPipelineAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await analyticsService.getPipelineAnalytics(userId);
  res.json({ success: true, message: "Pipeline analytics fetched successfully", data: result });
});

export const getTimelineData = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await analyticsService.getTimelineData(userId);
  res.json({ success: true, message: "Timeline data fetched successfully", data: result });
});

export const getSkillMatchAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await analyticsService.getSkillMatchAnalytics(userId);
  res.json({ success: true, message: "Skill match analytics fetched successfully", data: result });
});

export const getRejectionAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await analyticsService.getRejectionAnalytics(userId);
  res.json({ success: true, message: "Rejection analytics fetched successfully", data: result });
});
