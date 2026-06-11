import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/data/datasources/remote/ai_remote_datasource.dart';
import 'package:jobpilot_ai/data/models/api_response_model.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';
import 'package:jobpilot_ai/domain/entities/interview_result.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@LazySingleton(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource _remoteDataSource;

  AiRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ResumeAnalysis>> analyzeResume(String resumeId) async {
    try {
      final response = await _remoteDataSource.analyzeResume(resumeId);
      final apiResponse = ApiResponseModel<ResumeAnalysis>.fromJson(
        response,
        (data) => ResumeAnalysis.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(Failure.serverFailure(message: 'Failed to analyze resume'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, ResumeAnalysis>> getResumeAnalysis(
      String resumeId) async {
    try {
      final response = await _remoteDataSource.getResumeAnalysis(resumeId);
      final apiResponse = ApiResponseModel<ResumeAnalysis>.fromJson(
        response,
        (data) => ResumeAnalysis.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to get resume analysis'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<ResumeAnalysis>>> getResumeAnalyses() async {
    try {
      final response = await _remoteDataSource.getResumeAnalyses();
      final apiResponse = ApiResponseModel<List<ResumeAnalysis>>.fromJson(
        response,
        (data) => (data as List<dynamic>)
            .map((e) => ResumeAnalysis.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return Right(apiResponse.data ?? []);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, JobAnalysis>> analyzeJobDescription(
    String jobDescription, {
    String? jobId,
  }) async {
    try {
      final response = await _remoteDataSource.analyzeJobDescription(
        jobDescription,
        jobId: jobId,
      );
      final apiResponse = ApiResponseModel<JobAnalysis>.fromJson(
        response,
        (data) => JobAnalysis.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to analyze job description'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, JobAnalysis>> getJobAnalysis(String analysisId) async {
    try {
      final response = await _remoteDataSource.getJobAnalysis(analysisId);
      final apiResponse = ApiResponseModel<JobAnalysis>.fromJson(
        response,
        (data) => JobAnalysis.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to get job analysis'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<JobAnalysis>>> getJobAnalyses() async {
    try {
      final response = await _remoteDataSource.getJobAnalyses();
      final apiResponse = ApiResponseModel<List<JobAnalysis>>.fromJson(
        response,
        (data) => (data as List<dynamic>)
            .map((e) => JobAnalysis.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return Right(apiResponse.data ?? []);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> matchResumeAndJob(
    String resumeId,
    String jobDescription,
  ) async {
    try {
      final response =
          await _remoteDataSource.matchResumeAndJob(resumeId, jobDescription);
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response,
        (data) => data as Map<String, dynamic>,
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to match resume and job'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, JobAnalysis>> getMatchResult(String matchId) async {
    try {
      final response = await _remoteDataSource.getMatchResult(matchId);
      final apiResponse = ApiResponseModel<JobAnalysis>.fromJson(
        response,
        (data) => JobAnalysis.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to get match result'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, InterviewSession>> generateInterviewQuestions(
      String jobId) async {
    try {
      final response =
          await _remoteDataSource.generateInterviewQuestions(jobId);
      final apiResponse = ApiResponseModel<InterviewSession>.fromJson(
        response,
        (data) => InterviewSession.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(
                message: 'Failed to generate interview questions'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<InterviewSession>>> getInterviewSessions() async {
    try {
      final response = await _remoteDataSource.getInterviewSessions();
      final apiResponse = ApiResponseModel<List<InterviewSession>>.fromJson(
        response,
        (data) => (data as List<dynamic>)
            .map(
                (e) => InterviewSession.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return Right(apiResponse.data ?? []);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, InterviewSession>> getInterviewSession(
      String sessionId) async {
    try {
      final response =
          await _remoteDataSource.getInterviewSession(sessionId);
      final apiResponse = ApiResponseModel<InterviewSession>.fromJson(
        response,
        (data) => InterviewSession.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to get interview session'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitAnswer(
    String questionId,
    String answer,
  ) async {
    try {
      final response =
          await _remoteDataSource.submitAnswer(questionId, answer);
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response,
        (data) => data as Map<String, dynamic>,
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to submit answer'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, InterviewResult>> completeInterview(
      String sessionId) async {
    try {
      final response =
          await _remoteDataSource.completeInterview(sessionId);
      final apiResponse = ApiResponseModel<InterviewResult>.fromJson(
        response,
        (data) => InterviewResult.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to complete interview'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, InterviewResult>> getInterviewResult(
      String sessionId) async {
    try {
      final response =
          await _remoteDataSource.getInterviewResult(sessionId);
      final apiResponse = ApiResponseModel<InterviewResult>.fromJson(
        response,
        (data) => InterviewResult.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to get interview result'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, CareerInsight>> getCareerInsights() async {
    try {
      final response = await _remoteDataSource.getCareerInsights();
      final apiResponse = ApiResponseModel<CareerInsight>.fromJson(
        response,
        (data) => CareerInsight.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to get career insights'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<CareerInsight>>>
      getCareerInsightsHistory() async {
    try {
      final response = await _remoteDataSource.getCareerInsightsHistory();
      final apiResponse = ApiResponseModel<List<CareerInsight>>.fromJson(
        response,
        (data) => (data as List<dynamic>)
            .map((e) => CareerInsight.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return Right(apiResponse.data ?? []);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.error is AuthException) {
      return Failure.authFailure(
        message: (e.error as AuthException).message,
        code: (e.error as AuthException).statusCode,
      );
    } else if (e.error is ServerException) {
      return Failure.serverFailure(
        message: (e.error as ServerException).message,
        code: (e.error as ServerException).statusCode,
      );
    } else if (e.error is NetworkException) {
      return Failure.networkFailure(
        message: (e.error as NetworkException).message,
        code: (e.error as NetworkException).statusCode,
      );
    } else if (e.error is ValidationException) {
      return Failure.validationFailure(
        message: (e.error as ValidationException).message,
        code: (e.error as ValidationException).statusCode,
      );
    } else if (e.error is CacheException) {
      return Failure.cacheFailure(
        message: (e.error as CacheException).message,
        code: (e.error as CacheException).statusCode,
      );
    }
    return Failure.serverFailure(
      message: e.message ?? 'An unexpected error occurred',
    );
  }
}
