import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getPipelineAnalytics, getTimelineData, getSkillMatchAnalytics, getRejectionAnalytics } from "../controllers/analytics.controller";

/**
 * Express router for analytics and reporting endpoints.
 * Handles fetching pipeline metrics and timeline data for the user.
 */
const router = Router();

router.use(authenticate);

router.get("/pipeline", getPipelineAnalytics);
router.get("/timeline", getTimelineData);
router.get("/skills-match", getSkillMatchAnalytics);
router.get("/rejections", getRejectionAnalytics);

export default router;
