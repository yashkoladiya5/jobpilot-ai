import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getPipelineAnalytics, getTimelineData } from "../controllers/analytics.controller";

/**
 * Express router for analytics and reporting endpoints.
 * Handles fetching pipeline metrics and timeline data for the user.
 */
const router = Router();

router.use(authenticate);

router.get("/pipeline", getPipelineAnalytics);
router.get("/timeline", getTimelineData);

export default router;
