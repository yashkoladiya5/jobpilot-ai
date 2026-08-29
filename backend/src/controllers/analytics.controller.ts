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

export const getOfferAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await analyticsService.getOfferAnalytics(userId);
  res.json({ success: true, message: "Offer analytics fetched successfully", data: result });
});

export const getInterviewAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await analyticsService.getInterviewAnalytics(userId);
  res.json({ success: true, message: "Interview analytics fetched successfully", data: result });
});

export const getWeeklyActivitySummary = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await analyticsService.getWeeklyActivitySummary(userId);
  res.json({ success: true, message: "Weekly activity summary fetched successfully", data: result });
});

export const getResumeAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getResumeAnalytics(userId);
  
  res.json({ 
    success: true, 
    message: "Resume analytics aggregated successfully", 
    data: result 
  });
});

export const getInterviewTrends = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getInterviewTrends(userId);
  
  res.json({ 
    success: true, 
    message: "Interview trends aggregated successfully", 
    data: result 
  });
});

export const getJobSourceAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getJobSourceAnalytics(userId);
  
  res.json({ 
    success: true, 
    message: "Job source analytics aggregated successfully", 
    data: result 
  });
});

export const getSkillsGapAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getSkillsGapAnalytics(userId);
  
  res.json({ 
    success: true, 
    message: "Skills gap analytics generated successfully", 
    data: result 
  });
});

export const getOfferNegotiationInsights = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getOfferNegotiationInsights(userId);
  
  res.json({ 
    success: true, 
    message: "Offer negotiation insights generated successfully", 
    data: result 
  });
});

export const getCareerGrowthPotential = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getCareerGrowthPotential(userId);
  
  res.json({ 
    success: true, 
    message: "Career growth potential calculated successfully", 
    data: result 
  });
});

export const getPeerComparisonAnalytics = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getPeerComparisonAnalytics(userId);
  
  res.json({ 
    success: true, 
    message: "Peer comparison analytics generated successfully", 
    data: result 
  });
});

export const getOfferPredictor = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getOfferPredictor(userId);
  
  res.json({ 
    success: true, 
    message: "Offer predictor generated successfully", 
    data: result 
  });
});

export const getNetworkingROI = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getNetworkingROI(userId);
  
  res.json({ 
    success: true, 
    message: "Networking ROI calculated successfully", 
    data: result 
  });
});

export const getJobSearchEffectiveness = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getJobSearchEffectiveness(userId);
  
  res.json({ 
    success: true, 
    message: "Job search effectiveness calculated successfully", 
    data: result 
  });
});

export const getApplicationGhostingPredictor = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await analyticsService.getApplicationGhostingPredictor(userId);
  
  res.json({ 
    success: true, 
    message: "Application ghosting prediction calculated successfully", 
    data: result 
  });
});

export const trackLoginDuration = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { durationSeconds } = req.body;
  
  if (typeof durationSeconds !== 'number') {
     res.status(400).json({ success: false, message: "durationSeconds must be provided as a number." });
     return;
  }
  
  const result = await analyticsService.trackLoginDuration(userId, durationSeconds);
  
  res.status(200).json({ 
    success: true, 
    message: "Login duration tracked successfully", 
    data: result 
  });
});

export const getCustomDateRangeStats = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { startDate, endDate } = req.query;
  
  if (!startDate || !endDate) {
    res.status(400).json({ success: false, message: "startDate and endDate queries are required." });
    return;
  }
  
  const start = new Date(startDate as string);
  const end = new Date(endDate as string);
  
  const result = await analyticsService.getCustomDateRangeStats(userId, start, end);
  
  res.status(200).json({ 
    success: true, 
    message: "Custom date range stats fetched successfully", 
    data: result 
  });
});

export const exportAnalyticsReport = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const report = await analyticsService.exportAnalyticsReport(userId);
  
  res.status(200).json({
    success: true,
    message: "Analytics report exported successfully",
    data: report,
  });
});

export const getSkillDemandForecast = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const forecast = await analyticsService.getSkillDemandForecast(userId);
  
  res.status(200).json({
    success: true,
    message: "Skill demand forecast generated successfully",
    data: forecast,
  });
});
