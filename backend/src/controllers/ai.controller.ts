import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { ResumeAnalysisService } from "../services/ai/resume-analysis.service";
import { JobAnalysisService } from "../services/ai/job-analysis.service";
import { matchingService } from "../services/ai/matching.service";
import { interviewService } from "../services/ai/interview.service";
import { careerInsightsService } from "../services/ai/career-insights.service";

/**
 * Controller for AI Operations.
 * Wraps service calls for Resume/Job analysis, matchmaking, and interview prep.
 */
const resumeAnalysisService = new ResumeAnalysisService();
const jobAnalysisService = new JobAnalysisService();

// Resume Analysis

export const analyzeResume = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId } = req.params;
  
  if (!resumeId) {
     res.status(400).json({ success: false, message: "Resume ID is required for analysis." });
     return;
  }
  
  console.log(`[AI Controller] Starting resume analysis for user ${userId}, resume ${resumeId}`);
  const analysis = await resumeAnalysisService.analyzeResume(userId, resumeId);
  console.log(`[AI Controller] Finished resume analysis for resume ${resumeId}`);
  
  res.status(200).json({
    success: true,
    message: "Resume analysis completed successfully",
    data: analysis,
  });
});

export const getResumeAnalysis = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId } = req.params;
  const analysis = await resumeAnalysisService.getAnalysisByResume(resumeId, userId);
  res.status(200).json({
    success: true,
    message: "Resume analysis fetched successfully",
    data: analysis,
  });
});

export const getResumeAnalyses = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const analyses = await resumeAnalysisService.getUserAnalyses(userId);
  res.status(200).json({
    success: true,
    message: "Resume analyses fetched successfully",
    data: analyses,
  });
});

export const getLatestResumeAnalysis = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  console.log(`[AI Controller] Fetching latest resume analysis for user ${userId}`);
  const analysis = await resumeAnalysisService.getLatestResumeAnalysis(userId);
  
  res.status(200).json({
    success: true,
    message: "Latest resume analysis fetched successfully",
    data: analysis,
  });
});

export const getResumeRedFlags = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId } = req.params;
  
  if (!resumeId) {
     res.status(400).json({ success: false, message: "Resume ID is required." });
     return;
  }
  
  const result = await resumeAnalysisService.getResumeRedFlags(userId, resumeId);
  
  res.status(200).json({
    success: true,
    message: "Resume red flags generated successfully",
    data: result,
  });
});

export const getResumeKeywordOptimization = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId } = req.params;
  
  if (!resumeId) {
     res.status(400).json({ success: false, message: "Resume ID is required." });
     return;
  }
  
  const optimization = await resumeAnalysisService.getResumeKeywordOptimization(userId, resumeId);
  
  res.status(200).json({
    success: true,
    message: "Resume keyword optimization generated successfully",
    data: optimization,
  });
});

export const getSmartResumeSummary = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId } = req.params;
  
  if (!resumeId) {
     res.status(400).json({ success: false, message: "Resume ID is required." });
     return;
  }
  
  const summary = await resumeAnalysisService.generateSmartResumeSummary(userId, resumeId);
  
  res.status(200).json({
    success: true,
    message: "Smart resume summary generated successfully",
    data: summary,
  });
});

// Job Analysis

export const analyzeJob = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobDescription, jobId } = req.body;
  const analysis = await jobAnalysisService.analyzeJobDescription(userId, jobDescription, jobId);
  res.status(200).json({
    success: true,
    message: "Job analysis completed",
    data: analysis,
  });
});

export const getJobAnalysis = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { analysisId } = req.params;
  const analysis = await jobAnalysisService.getAnalysisById(analysisId, userId);
  res.status(200).json({
    success: true,
    message: "Job analysis fetched successfully",
    data: analysis,
  });
});

export const getJobAnalyses = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const analyses = await jobAnalysisService.getUserAnalyses(userId);
  res.status(200).json({
    success: true,
    message: "Job analyses fetched successfully",
    data: analyses,
  });
});

export const deleteJobAnalysis = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { analysisId } = req.params;
  await jobAnalysisService.deleteJobAnalysis(analysisId, userId);
  res.status(200).json({ success: true, message: "Job analysis deleted successfully", data: null });
});

export const deleteResumeAnalysis = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { analysisId } = req.params;
  await resumeAnalysisService.deleteResumeAnalysis(analysisId, userId);
  res.status(200).json({ success: true, message: "Resume analysis deleted successfully", data: null });
});

export const generateCoverLetter = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobDescription, resumeId } = req.body;
  
  if (!jobDescription) {
     res.status(400).json({ success: false, message: "Job description is required to generate a cover letter." });
     return;
  }

  const coverLetter = await jobAnalysisService.generateCoverLetter(userId, jobDescription, resumeId);
  
  res.status(200).json({ 
    success: true, 
    message: "Cover letter generated successfully", 
    data: coverLetter 
  });
});

// Resume Matching

export const matchResumeJob = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId, jobDescription } = req.body;
  if (!resumeId || !jobDescription) {
    res.status(400).json({ success: false, message: "resumeId and jobDescription are required", data: null });
    return;
  }
  const result = await matchingService.matchResumeAndJob(userId, resumeId, jobDescription);
  res.json({ success: true, message: "Match analysis completed", data: result });
});

export const getMatchResult = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { matchId } = req.params;
  const result = await matchingService.getMatchResult(matchId, userId);
  res.json({ success: true, message: "Match result fetched", data: result });
});

export const getTopMatches = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId } = req.params;
  const { limit } = req.query;
  
  const parsedLimit = limit ? parseInt(limit as string, 10) : 5;
  const matches = await matchingService.getTopMatchesForResume(resumeId, userId, parsedLimit);
  
  res.status(200).json({
    success: true,
    message: "Top matches fetched successfully",
    data: matches,
  });
});

export const getMatchDetails = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { matchId } = req.params;
  
  if (!matchId) {
     res.status(400).json({ success: false, message: "Match ID is required to fetch details." });
     return;
  }

  const result = await matchingService.getMatchDetails(matchId, userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Match detailed breakdown fetched successfully", 
    data: result 
  });
});

export const getRecentMatches = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { limit } = req.query;
  
  const parsedLimit = limit ? parseInt(limit as string, 10) : 5;
  const matches = await matchingService.getRecentMatches(userId, parsedLimit);
  
  res.status(200).json({
    success: true,
    message: "Recent matches fetched successfully",
    data: matches,
  });
});

// Interview Prep

export const generateInterview = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobId } = req.params;
  const result = await interviewService.generateQuestions(userId, jobId);
  res.json({ success: true, message: "Interview questions generated", data: result });
});

export const getInterviewSessions = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await interviewService.getSessions(userId);
  res.json({ success: true, message: "Interview sessions fetched", data: result });
});

export const getInterviewSession = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { sessionId } = req.params;
  const result = await interviewService.getSession(sessionId, userId);
  res.json({ success: true, message: "Interview session fetched", data: result });
});

export const submitAnswer = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { questionId, answer } = req.body;
  if (!questionId || !answer) {
    res.status(400).json({ success: false, message: "questionId and answer are required", data: null });
    return;
  }
  const result = await interviewService.submitAnswer(questionId, answer, userId);
  res.json({ success: true, message: "Answer submitted", data: result });
});

export const completeInterview = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { sessionId } = req.params;
  const result = await interviewService.completeSession(sessionId, userId);
  res.json({ success: true, message: "Interview completed", data: result });
});

export const getInterviewResult = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { sessionId } = req.params;
  const result = await interviewService.getResult(sessionId, userId);
  res.json({ success: true, message: "Interview result fetched", data: result });
});

export const resetInterviewSession = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { sessionId } = req.params;
  const result = await interviewService.resetSession(sessionId, userId);
  res.json({ success: true, message: "Interview session reset successfully", data: result });
});

export const deleteInterviewSession = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { sessionId } = req.params;
  
  if (!sessionId) {
     res.status(400).json({ success: false, message: "Session ID is required for deletion." });
     return;
  }

  const result = await interviewService.deleteSession(sessionId, userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Interview session permanently deleted", 
    data: result 
  });
});

export const archiveInterviewSession = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { sessionId } = req.params;
  
  if (!sessionId) {
     res.status(400).json({ success: false, message: "Session ID is required for archiving." });
     return;
  }

  const result = await interviewService.archiveInterviewSession(sessionId, userId);
  
  res.status(200).json({ 
    success: true, 
    message: "Interview session archived successfully", 
    data: result 
  });
});

export const getInterviewTips = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  console.log(`[AI Controller] Fetching interview tips for user ${userId}`);
  const tips = await interviewService.getInterviewTips(userId);
  
  res.status(200).json({
    success: true,
    message: "Interview tips generated successfully",
    data: tips,
  });
});

export const getInterviewCategoryStats = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const stats = await interviewService.getInterviewCategoryStats(userId);
  
  res.status(200).json({
    success: true,
    message: "Interview category stats generated successfully",
    data: stats,
  });
});

export const getInterviewReadinessScore = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const score = await interviewService.getInterviewReadinessScore(userId);
  
  res.status(200).json({
    success: true,
    message: "Interview readiness score generated successfully",
    data: score,
  });
});

export const generateMockTechnicalAssessment = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobId } = req.params;
  
  if (!jobId) {
     res.status(400).json({ success: false, message: "Job ID is required." });
     return;
  }
  
  const assessment = await interviewService.generateMockTechnicalAssessment(userId, jobId);
  
  res.status(200).json({
    success: true,
    message: "Mock technical assessment generated successfully",
    data: assessment,
  });
});

export const generateMockBehavioralAssessment = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobId } = req.params;
  
  if (!jobId) {
     res.status(400).json({ success: false, message: "Job ID is required." });
     return;
  }
  
  const assessment = await interviewService.generateMockBehavioralAssessment(userId, jobId);
  
  res.status(200).json({
    success: true,
    message: "Mock behavioral assessment generated successfully",
    data: assessment,
  });
});

export const generateMockSystemDesignAssessment = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobId } = req.params;
  
  if (!jobId) {
     res.status(400).json({ success: false, message: "Job ID is required." });
     return;
  }
  
  const assessment = await interviewService.generateMockSystemDesignAssessment(userId, jobId);
  
  res.status(200).json({
    success: true,
    message: "Mock system design assessment generated successfully",
    data: assessment,
  });
});

// Career Insights

export const getCareerInsights = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const insights = await careerInsightsService.getLatestInsights(userId);
  if (!insights) {
    const result = await careerInsightsService.computeInsights(userId);
    res.json({ success: true, message: "Career insights computed", data: result });
    return;
  }
  res.json({ success: true, message: "Career insights fetched", data: insights });
});

export const computeCareerInsights = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  // Force a re-computation of insights rather than using cached
  console.log(`[AI Controller] Forcing compute career insights for user ${userId}`);
  const result = await careerInsightsService.computeInsights(userId, { forceRefresh: true });
  
  res.json({ success: true, message: "Career insights forcefully re-computed", data: result });
});

export const getCareerInsightsHistory = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await careerInsightsService.getInsightsHistory(userId);
  res.json({ success: true, message: "Career insights history fetched", data: result });
});

export const deleteCareerInsightsHistory = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  console.log(`[AI Controller] Deleting career insights history for user ${userId}`);
  const result = await careerInsightsService.deleteInsightsHistory(userId);
  
  res.status(200).json({
    success: true,
    message: "Career insights history deleted successfully",
    data: result,
  });
});

export const extractJobKeywords = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobDescription } = req.body;
  
  if (!jobDescription) {
     res.status(400).json({ success: false, message: "Job description is required." });
     return;
  }
  
  const keywords = await interviewService.extractJobKeywords(userId, jobDescription);
  
  res.status(200).json({
    success: true,
    message: "Job keywords extracted successfully",
    data: keywords,
  });
});

export const detectJobRedFlags = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobDescription } = req.body;
  
  if (!jobDescription) {
     res.status(400).json({ success: false, message: "Job description is required." });
     return;
  }
  
  const result = await jobAnalysisService.detectJobRedFlags(userId, jobDescription);
  
  res.status(200).json({
    success: true,
    message: "Job red flags detected successfully",
    data: result,
  });
});

export const generateElevatorPitch = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { jobId } = req.params;
  
  if (!jobId) {
     res.status(400).json({ success: false, message: "Job ID is required." });
     return;
  }
  
  const result = await interviewService.generateElevatorPitch(userId, jobId);
  
  res.status(200).json({
    success: true,
    message: "Elevator pitch generated successfully",
    data: result,
  });
});

export const rewriteCoverLetterTone = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { currentCoverLetter, targetTone } = req.body;
  
  if (!currentCoverLetter || !targetTone) {
     res.status(400).json({ success: false, message: "Cover letter and target tone are required." });
     return;
  }
  
  const result = await jobAnalysisService.rewriteCoverLetterTone(userId, currentCoverLetter, targetTone);
  
  res.status(200).json({
    success: true,
    message: "Cover letter tone adjusted successfully",
    data: result,
  });
});

export const highlightCoverLetterKeywords = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { coverLetter, jobDescription } = req.body;
  
  if (!coverLetter || !jobDescription) {
     res.status(400).json({ success: false, message: "Cover letter and job description are required." });
     return;
  }
  
  const result = await jobAnalysisService.highlightCoverLetterKeywords(userId, coverLetter, jobDescription);
  
  res.status(200).json({
    success: true,
    message: "Cover letter keywords highlighted successfully",
    data: result,
  });
});
