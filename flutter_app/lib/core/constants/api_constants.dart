import 'package:jobpilot_ai/core/constants/app_constants.dart';

class ApiConstants {
  ApiConstants._();

  static String get _baseUrl => AppConstants.apiBaseUrl;

  static String get login => '$_baseUrl/auth/login';
  static String get register => '$_baseUrl/auth/register';
  static String get me => '$_baseUrl/auth/me';

  static String get jobs => '$_baseUrl/jobs';
  static String jobDetail(String id) => '$_baseUrl/jobs/$id';

  static String get resumes => '$_baseUrl/resumes';
  static String resumeDetail(String id) => '$_baseUrl/resumes/$id';
  static String get uploadResume => '$_baseUrl/resumes/upload';
  static String resumeSetPrimary(String id) => '$_baseUrl/resumes/$id/primary';

  static String get dashboardStats => '$_baseUrl/dashboard/stats';

  // AI endpoints
  static String resumeAnalyze(String resumeId) => '$_baseUrl/ai/resume/analyze/$resumeId';
  static String resumeAnalysis(String resumeId) => '$_baseUrl/ai/resume/analysis/$resumeId';
  static String get resumeAnalyses => '$_baseUrl/ai/resume/analyses';
  static String get jobAnalyze => '$_baseUrl/ai/job/analyze';
  static String jobAnalysis(String id) => '$_baseUrl/ai/job/analysis/$id';
  static String get jobAnalyses => '$_baseUrl/ai/job/analyses';
  static String get match => '$_baseUrl/ai/match';
  static String matchResult(String id) => '$_baseUrl/ai/match/$id';
  static String interviewGenerate(String jobId) => '$_baseUrl/ai/interview/generate/$jobId';
  static String get interviewSessions => '$_baseUrl/ai/interview/sessions';
  static String interviewSession(String id) => '$_baseUrl/ai/interview/session/$id';
  static String get interviewAnswer => '$_baseUrl/ai/interview/answer';
  static String interviewComplete(String id) => '$_baseUrl/ai/interview/complete/$id';
  static String interviewResult(String id) => '$_baseUrl/ai/interview/result/$id';
  static String get careerInsights => '$_baseUrl/ai/insights';
  static String get careerInsightsHistory => '$_baseUrl/ai/insights/history';
}
