import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { DashboardService } from "../services/dashboard.service";

/**
 * Controller for Dashboard operations.
 * Fetches user statistics and recent activity for the home view.
 */
const dashboardService = new DashboardService();

/**
 * Retrieves dashboard statistics for the currently authenticated user.
 * Provides high-level aggregations of user activities.
 */
export const getStats = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const data = await dashboardService.getStats(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Dashboard statistics successfully fetched and aggregated", 
    data: data,
    meta: {
      timestamp: new Date().toISOString(),
      source: "dashboard_service"
    }
  });
});

export const getRecentActivityLogs = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { limit } = req.query;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const parsedLimit = limit ? parseInt(limit as string, 10) : 10;
  const activityLogs = await dashboardService.getRecentActivityLogs(userId, parsedLimit);
  
  res.status(200).json({ 
    success: true, 
    message: "Recent activity logs fetched successfully", 
    data: activityLogs,
  });
});

export const getActionItems = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const actionItems = await dashboardService.getActionItems(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Action items fetched successfully", 
    data: actionItems,
  });
});

export const getDashboardSummary = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const summary = await dashboardService.getDashboardSummary(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Dashboard summary fetched successfully", 
    data: summary,
  });
});

export const getDashboardAlerts = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const alerts = await dashboardService.getDashboardAlerts(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Dashboard alerts fetched successfully", 
    data: alerts,
  });
});

export const getUpcomingEvents = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const events = await dashboardService.getUpcomingEvents(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Upcoming events fetched successfully", 
    data: events,
  });
});

export const getDailyGoals = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const goals = await dashboardService.getDailyGoals(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Daily goals fetched successfully", 
    data: goals,
  });
});

export const getRecommendedJobs = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const recommendations = await dashboardService.getRecommendedJobs(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Recommended jobs fetched successfully", 
    data: recommendations,
  });
});

export const getWeeklySnapshot = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const snapshot = await dashboardService.getWeeklySnapshot(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Weekly snapshot fetched successfully", 
    data: snapshot,
  });
});

export const getTopSkillsTrending = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const trendingSkills = await dashboardService.getTopSkillsTrending(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Trending skills fetched successfully", 
    data: trendingSkills,
  });
});

export const getGamificationScore = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const score = await dashboardService.getGamificationScore(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Gamification score fetched successfully", 
    data: score,
  });
});

export const getSkillGapAnalysis = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const analysis = await dashboardService.getSkillGapAnalysis(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Skill gap analysis fetched successfully", 
    data: analysis,
  });
});

export const getBurnoutPredictor = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const predictor = await dashboardService.getBurnoutPredictor(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Burnout predictor fetched successfully", 
    data: predictor,
  });
});

export const getMorningBriefing = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const briefing = await dashboardService.getMorningBriefing(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Morning briefing fetched successfully", 
    data: briefing,
  });
});

export const getConsistencyTracker = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const tracker = await dashboardService.getConsistencyTracker(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Consistency tracker fetched successfully", 
    data: tracker,
  });
});

export const generateWeeklyReport = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }

  const report = await dashboardService.generateWeeklyReport(userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Weekly activity report generated successfully", 
    data: report,
  });
});

export const updateNotificationPreferences = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const preferences = req.body;
  
  if (!userId) {
     res.status(401).json({ success: false, message: "Unauthorized access: user ID is missing" });
     return;
  }
  
  const result = await dashboardService.updateNotificationPreferences(userId, preferences);
  
  res.status(200).json({ 
    success: true, 
    message: "Notification preferences updated", 
    data: result,
  });
});

export const snoozeNotifications = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { snoozeDays } = req.body;
  
  const result = await dashboardService.snoozeNotifications(userId, snoozeDays);
  
  res.status(200).json({ 
    success: true, 
    message: "Notifications snoozed successfully", 
    data: result,
  });
});

export const dismissAlert = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { alertId } = req.params;
  
  const result = await dashboardService.dismissAlert(userId, alertId);
  
  res.status(200).json({
    success: true,
    message: "Alert dismissed successfully",
    data: result,
  });
});

export const pinAlert = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { alertId } = req.params;
  
  const result = await dashboardService.pinAlert(userId, alertId);
  
  res.status(200).json({
    success: true,
    message: "Alert pinned successfully",
    data: result,
  });
});

export const dismissAllAlerts = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await dashboardService.dismissAllAlerts(userId);

  res.status(200).json({
    success: true,
    message: "All alerts dismissed successfully",
    data: result,
  });
});

export const clearAllActionItems = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const result = await dashboardService.clearAllActionItems(userId);

  res.status(200).json({
    success: true,
    message: "Action items cleared successfully",
    data: result,
  });
});
