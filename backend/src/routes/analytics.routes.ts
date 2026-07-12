import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getPipelineAnalytics, getTimelineData } from "../controllers/analytics.controller";

const router = Router();

router.use(authenticate);

router.get("/pipeline", getPipelineAnalytics);
router.get("/timeline", getTimelineData);

export default router;
