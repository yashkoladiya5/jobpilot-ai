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
