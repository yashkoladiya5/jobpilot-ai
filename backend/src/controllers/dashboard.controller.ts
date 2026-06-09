import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { DashboardService } from "../services/dashboard.service";

const dashboardService = new DashboardService();

export const getStats = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const data = await dashboardService.getStats(userId);
  res.status(200).json({ success: true, data });
});
