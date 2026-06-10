import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthenticatedRequest } from "../middleware/auth";
import { ResumeAnalysisService } from "../services/ai/resume-analysis.service";
import { JobAnalysisService } from "../services/ai/job-analysis.service";
import { matchingService } from "../services/ai/matching.service";
import { interviewService } from "../services/ai/interview.service";
import { careerInsightsService } from "../services/ai/career-insights.service";

const resumeAnalysisService = new ResumeAnalysisService();
const jobAnalysisService = new JobAnalysisService();

// Resume Analysis

export const analyzeResume = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { resumeId } = req.params;
  const analysis = await resumeAnalysisService.analyzeResume(userId, resumeId);
  res.status(200).json({
    success: true,
    message: "Resume analysis completed",
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

export const getCareerInsightsHistory = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const result = await careerInsightsService.getInsightsHistory(userId);
  res.json({ success: true, message: "Career insights history fetched", data: result });
});
