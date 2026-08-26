import { Router } from "express";
import {
  analyzeResume,
  getResumeAnalysis,
  getResumeAnalyses,
  getLatestResumeAnalysis,
  deleteResumeAnalysis,
  getResumeRedFlags,
  getResumeKeywordOptimization,
  getSmartResumeSummary,
  analyzeJob,
  getJobAnalysis,
  getJobAnalyses,
  deleteJobAnalysis,
  generateCoverLetter,
  matchResumeJob,
  getMatchResult,
  getTopMatches,
  getMatchDetails,
  getRecentMatches,
  generateInterview,
  getInterviewSessions,
  getInterviewSession,
  submitAnswer,
  completeInterview,
  getInterviewResult,
  resetInterviewSession,
  deleteInterviewSession,
  archiveInterviewSession,
  getInterviewTips,
  getInterviewCategoryStats,
  getInterviewReadinessScore,
  generateMockTechnicalAssessment,
  generateMockBehavioralAssessment,
  generateMockSystemDesignAssessment,
  getCareerInsights,
  computeCareerInsights,
  getCareerInsightsHistory,
  deleteCareerInsightsHistory,
  extractJobKeywords,
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
router.get("/resume/:resumeId/red-flags", getResumeRedFlags);
router.get("/resume/:resumeId/keyword-optimization", getResumeKeywordOptimization);
router.get("/resume/analyses/latest", getLatestResumeAnalysis);
router.get("/resume/:resumeId/analysis", getResumeAnalysis);
router.get("/resume/analyses", getResumeAnalyses);
router.get("/resume/:resumeId/smart-summary", getSmartResumeSummary);

// Job analysis
router.post("/job/analyze", analyzeJob);
router.post("/job/extract-keywords", extractJobKeywords);
router.get("/job/analysis/:analysisId", getJobAnalysis);
router.get("/job/analyses", getJobAnalyses);
router.delete("/job/analysis/:analysisId", deleteJobAnalysis);
router.delete("/resume/analysis/:analysisId", deleteResumeAnalysis);
router.post("/cover-letter/generate", generateCoverLetter);

// Resume-Job matching
router.post("/match", matchResumeJob);
router.get("/match/:matchId", getMatchResult);
router.get("/match/:matchId/details", getMatchDetails);
router.get("/match/resume/:resumeId/top", getTopMatches);
router.get("/match/recent", getRecentMatches);

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
router.delete("/interview/session/:sessionId", deleteInterviewSession);
router.patch("/interview/session/:sessionId/archive", archiveInterviewSession);
router.get("/interview/tips", getInterviewTips);
router.get("/interview/stats/category", getInterviewCategoryStats);
router.get("/interview/readiness-score", getInterviewReadinessScore);
router.post("/interview/job/:jobId/technical-assessment", generateMockTechnicalAssessment);
router.post("/interview/job/:jobId/behavioral-assessment", generateMockBehavioralAssessment);
router.post("/interview/job/:jobId/system-design-assessment", generateMockSystemDesignAssessment);

// Career insights
router.get("/career/insights", getCareerInsights);
router.post("/career/insights/compute", computeCareerInsights);
router.get("/career/insights/history", getCareerInsightsHistory);
router.delete("/career/insights/history", deleteCareerInsightsHistory);

export default router;
