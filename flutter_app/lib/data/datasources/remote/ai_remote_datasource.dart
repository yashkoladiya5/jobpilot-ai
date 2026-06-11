import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/constants/api_constants.dart';
import 'package:jobpilot_ai/core/network/dio_client.dart';

@lazySingleton
class AiRemoteDataSource {
  final DioClient _dioClient;
  AiRemoteDataSource(this._dioClient);

  // Resume Analysis
  Future<Map<String, dynamic>> analyzeResume(String resumeId) async {
    final response = await _dioClient.post(
      ApiConstants.resumeAnalyze(resumeId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getResumeAnalysis(String resumeId) async {
    final response = await _dioClient.get(
      ApiConstants.resumeAnalysis(resumeId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getResumeAnalyses() async {
    final response = await _dioClient.get(ApiConstants.resumeAnalyses);
    return response.data as Map<String, dynamic>;
  }

  // Job Analysis
  Future<Map<String, dynamic>> analyzeJobDescription(
    String jobDescription, {
    String? jobId,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.jobAnalyze,
      data: {
        'jobDescription': jobDescription,
        // ignore: use_null_aware_elements
        if (jobId != null) 'jobId': jobId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getJobAnalysis(String analysisId) async {
    final response = await _dioClient.get(
      ApiConstants.jobAnalysis(analysisId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getJobAnalyses() async {
    final response = await _dioClient.get(ApiConstants.jobAnalyses);
    return response.data as Map<String, dynamic>;
  }

  // Resume Matching
  Future<Map<String, dynamic>> matchResumeAndJob(
    String resumeId,
    String jobDescription,
  ) async {
    final response = await _dioClient.post(
      ApiConstants.match,
      data: {
        'resumeId': resumeId,
        'jobDescription': jobDescription,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMatchResult(String matchId) async {
    final response = await _dioClient.get(ApiConstants.matchResult(matchId));
    return response.data as Map<String, dynamic>;
  }

  // Interview Prep
  Future<Map<String, dynamic>> generateInterviewQuestions(String jobId) async {
    final response = await _dioClient.post(
      ApiConstants.interviewGenerate(jobId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInterviewSessions() async {
    final response = await _dioClient.get(ApiConstants.interviewSessions);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInterviewSession(String sessionId) async {
    final response = await _dioClient.get(
      ApiConstants.interviewSession(sessionId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitAnswer(
    String questionId,
    String answer,
  ) async {
    final response = await _dioClient.post(
      ApiConstants.interviewAnswer,
      data: {
        'questionId': questionId,
        'answer': answer,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> completeInterview(String sessionId) async {
    final response = await _dioClient.post(
      ApiConstants.interviewComplete(sessionId),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInterviewResult(String sessionId) async {
    final response = await _dioClient.get(
      ApiConstants.interviewResult(sessionId),
    );
    return response.data as Map<String, dynamic>;
  }

  // Career Insights
  Future<Map<String, dynamic>> getCareerInsights() async {
    final response = await _dioClient.get(ApiConstants.careerInsights);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCareerInsightsHistory() async {
    final response = await _dioClient.get(ApiConstants.careerInsightsHistory);
    return response.data as Map<String, dynamic>;
  }
}
