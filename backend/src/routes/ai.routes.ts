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
  getCareerInsights,
  getCareerInsightsHistory,
} from "../controllers/ai.controller";
import { authenticate } from "../middleware/auth";

const router = Router();

router.use(authenticate);

// Resume analysis
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

// Interview prep
router.post("/interview/generate", generateInterview);
router.get("/interview/sessions", getInterviewSessions);
router.get("/interview/session/:sessionId", getInterviewSession);
router.post("/interview/session/:sessionId/answer", submitAnswer);
router.post("/interview/session/:sessionId/complete", completeInterview);
router.get("/interview/session/:sessionId/result", getInterviewResult);

// Career insights
router.get("/career/insights", getCareerInsights);
router.get("/career/insights/history", getCareerInsightsHistory);

export default router;
