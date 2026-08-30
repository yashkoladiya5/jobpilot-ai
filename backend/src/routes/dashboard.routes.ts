import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getStats, getRecentActivityLogs, getActionItems, getDashboardSummary, getDashboardAlerts, getUpcomingEvents, getDailyGoals, getRecommendedJobs, getWeeklySnapshot, getTopSkillsTrending, getGamificationScore, getSkillGapAnalysis, getBurnoutPredictor, getMorningBriefing, getConsistencyTracker, generateWeeklyReport, updateNotificationPreferences, snoozeNotifications, dismissAlert, pinAlert, dismissAllAlerts, clearAllActionItems, updateWidgetPreferences, getGoalStreaks, getCareerMilestones, getApplicationFlowFunnel, getUpcomingDeadlines } from "../controllers/dashboard.controller";

/**
 * Express router for dashboard endpoints.
 * Fetches user statistics and recent activity for the home view.
 */
const router = Router();

router.get("/stats", authenticate, getStats);
router.get("/activity", authenticate, getRecentActivityLogs);
router.get("/action-items", authenticate, getActionItems);
router.patch("/action-items/clear", authenticate, clearAllActionItems);
router.get("/summary", authenticate, getDashboardSummary);
router.get("/alerts", authenticate, getDashboardAlerts);
router.get("/upcoming-events", authenticate, getUpcomingEvents);
router.get("/daily-goals", authenticate, getDailyGoals);
router.get("/recommended-jobs", authenticate, getRecommendedJobs);
router.get("/weekly-snapshot", authenticate, getWeeklySnapshot);
router.get("/trending-skills", authenticate, getTopSkillsTrending);
router.get("/gamification-score", authenticate, getGamificationScore);
router.get("/skill-gaps", authenticate, getSkillGapAnalysis);
router.get("/burnout-predictor", authenticate, getBurnoutPredictor);
router.get("/morning-briefing", authenticate, getMorningBriefing);
router.get("/consistency-tracker", authenticate, getConsistencyTracker);
router.get("/weekly-report", authenticate, generateWeeklyReport);
router.patch("/notifications/preferences", authenticate, updateNotificationPreferences);
router.post("/notifications/snooze", authenticate, snoozeNotifications);
router.post("/alerts/:alertId/dismiss", authenticate, dismissAlert);
router.patch("/alerts/dismiss-all", authenticate, dismissAllAlerts);
router.patch("/alerts/:alertId/pin", authenticate, pinAlert);
router.patch("/widget/preferences", authenticate, updateWidgetPreferences);
router.get("/goal-streaks", authenticate, getGoalStreaks);
router.get("/career-milestones", authenticate, getCareerMilestones);
router.get("/flow-funnel", authenticate, getApplicationFlowFunnel);
router.get("/upcoming-deadlines", authenticate, getUpcomingDeadlines);

export default router;
