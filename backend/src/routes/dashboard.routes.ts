import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getStats, getRecentActivityLogs, getActionItems, getDashboardSummary } from "../controllers/dashboard.controller";

/**
 * Express router for dashboard endpoints.
 * Fetches user statistics and recent activity for the home view.
 */
const router = Router();

router.get("/stats", authenticate, getStats);
router.get("/activity", authenticate, getRecentActivityLogs);
router.get("/action-items", authenticate, getActionItems);
router.get("/summary", authenticate, getDashboardSummary);

export default router;
