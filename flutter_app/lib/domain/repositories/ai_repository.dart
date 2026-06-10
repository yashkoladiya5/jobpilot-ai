import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';
import 'package:jobpilot_ai/domain/entities/interview_result.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';

abstract class AiRepository {
  // Resume Analysis
  Future<Either<Failure, ResumeAnalysis>> analyzeResume(String resumeId);
  Future<Either<Failure, ResumeAnalysis>> getResumeAnalysis(String resumeId);
  Future<Either<Failure, List<ResumeAnalysis>>> getResumeAnalyses();

  // Job Analysis
  Future<Either<Failure, JobAnalysis>> analyzeJobDescription(
      String jobDescription,
      {String? jobId});
  Future<Either<Failure, JobAnalysis>> getJobAnalysis(String analysisId);
  Future<Either<Failure, List<JobAnalysis>>> getJobAnalyses();

  // Resume Matching
  Future<Either<Failure, Map<String, dynamic>>> matchResumeAndJob(
      String resumeId, String jobDescription);
  Future<Either<Failure, JobAnalysis>> getMatchResult(String matchId);

  // Interview Prep
  Future<Either<Failure, InterviewSession>> generateInterviewQuestions(
      String jobId);
  Future<Either<Failure, List<InterviewSession>>> getInterviewSessions();
  Future<Either<Failure, InterviewSession>> getInterviewSession(
      String sessionId);
  Future<Either<Failure, Map<String, dynamic>>> submitAnswer(
      String questionId, String answer);
  Future<Either<Failure, InterviewResult>> completeInterview(String sessionId);
  Future<Either<Failure, InterviewResult>> getInterviewResult(String sessionId);

  // Career Insights
  Future<Either<Failure, CareerInsight>> getCareerInsights();
  Future<Either<Failure, List<CareerInsight>>> getCareerInsightsHistory();
}
