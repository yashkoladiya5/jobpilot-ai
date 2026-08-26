import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getStats, getRecentActivityLogs, getActionItems, getDashboardSummary, getDashboardAlerts, getUpcomingEvents, getDailyGoals, getRecommendedJobs, getWeeklySnapshot, getTopSkillsTrending, getGamificationScore, getSkillGapAnalysis } from "../controllers/dashboard.controller";

/**
 * Express router for dashboard endpoints.
 * Fetches user statistics and recent activity for the home view.
 */
const router = Router();

router.get("/stats", authenticate, getStats);
router.get("/activity", authenticate, getRecentActivityLogs);
router.get("/action-items", authenticate, getActionItems);
router.get("/summary", authenticate, getDashboardSummary);
router.get("/alerts", authenticate, getDashboardAlerts);
router.get("/upcoming-events", authenticate, getUpcomingEvents);
router.get("/daily-goals", authenticate, getDailyGoals);
router.get("/recommended-jobs", authenticate, getRecommendedJobs);
router.get("/weekly-snapshot", authenticate, getWeeklySnapshot);
router.get("/trending-skills", authenticate, getTopSkillsTrending);
router.get("/gamification-score", authenticate, getGamificationScore);
router.get("/skill-gaps", authenticate, getSkillGapAnalysis);

export default router;
