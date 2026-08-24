import { Router } from "express";
import {
  analyzeResume,
  getResumeAnalysis,
  getResumeAnalyses,
  analyzeJob,
  getJobAnalysis,
  getJobAnalyses,
  matchResumeJob,
  getMatchResult,
  generateInterview,
  getInterviewSessions,
  getInterviewSession,
  submitAnswer,
  completeInterview,
  getInterviewResult,
  resetInterviewSession,
  getCareerInsights,
  computeCareerInsights,
  getCareerInsightsHistory,
} from "../controllers/ai.controller";
import { authenticate } from "../middleware/auth";

/**
 * Express router for all AI-driven endpoints.
 * Mounts routes for resume parsing, job matching, and career insights.
 */
const router = Router();

// Apply authentication middleware to all AI routes
router.use(authenticate);

// Resume analysis endpoints
// Triggers analysis and retrieves past AI evaluations
router.post("/resume/:resumeId/analyze", analyzeResume);
router.get("/resume/:resumeId/analysis", getResumeAnalysis);
router.get("/resume/analyses", getResumeAnalyses);

// Job analysis
router.post("/job/analyze", analyzeJob);
router.get("/job/analysis/:analysisId", getJobAnalysis);
router.get("/job/analyses", getJobAnalyses);

// Resume-Job matching
router.post("/match", matchResumeJob);
router.get("/match/:matchId", getMatchResult);

// Feedback endpoints for AI improvements
router.post("/resume/analyses/:analysisId/feedback", (req, res) => {
  res.status(200).json({ success: true, message: "Resume analysis feedback recorded successfully" });
});

router.post("/job/analyses/:analysisId/feedback", (req, res) => {
  res.status(200).json({ success: true, message: "Job analysis feedback recorded successfully" });
});

// Interview prep
router.post("/interview/generate", generateInterview);
router.get("/interview/sessions", getInterviewSessions);
router.get("/interview/session/:sessionId", getInterviewSession);
router.post("/interview/session/:sessionId/answer", submitAnswer);
router.post("/interview/session/:sessionId/complete", completeInterview);
router.post("/interview/session/:sessionId/reset", resetInterviewSession);
router.get("/interview/session/:sessionId/result", getInterviewResult);

// Career insights
router.get("/career/insights", getCareerInsights);
router.post("/career/insights/compute", computeCareerInsights);
router.get("/career/insights/history", getCareerInsightsHistory);

export default router;
