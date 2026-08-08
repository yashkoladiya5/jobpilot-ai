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
  const data = await dashboardService.getStats(userId);
  res.status(200).json({ success: true, message: "Dashboard stats fetched successfully", data });
});
