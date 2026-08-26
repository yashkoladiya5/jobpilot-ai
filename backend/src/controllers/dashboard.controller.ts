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
