import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getPipelineAnalytics, getTimelineData, getSkillMatchAnalytics, getRejectionAnalytics, getOfferAnalytics, getInterviewAnalytics, getWeeklyActivitySummary, getResumeAnalytics, getInterviewTrends, getJobSourceAnalytics, getSkillsGapAnalytics, getOfferNegotiationInsights, getCareerGrowthPotential, getPeerComparisonAnalytics, getOfferPredictor, getNetworkingROI, getJobSearchEffectiveness, getApplicationGhostingPredictor } from "../controllers/analytics.controller";

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
router.get("/offers", getOfferAnalytics);
router.get("/interviews", getInterviewAnalytics);
router.get("/weekly-summary", getWeeklyActivitySummary);
router.get("/resume", getResumeAnalytics);
router.get("/interview-trends", getInterviewTrends);
router.get("/job-sources", getJobSourceAnalytics);
router.get("/skills-gap", getSkillsGapAnalytics);
router.get("/offers/negotiation-insights", getOfferNegotiationInsights);
router.get("/offers/predictor", getOfferPredictor);
router.get("/career-growth", getCareerGrowthPotential);
router.get("/peer-comparison", getPeerComparisonAnalytics);
router.get("/networking-roi", getNetworkingROI);
router.get("/effectiveness", getJobSearchEffectiveness);
router.get("/ghosting-predictor", getApplicationGhostingPredictor);

export default router;
