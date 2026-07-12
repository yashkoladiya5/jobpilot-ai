import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:jobpilot_ai/data/models/api_response_model.dart';
import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';
import 'package:jobpilot_ai/domain/repositories/analytics_repository.dart';

@LazySingleton(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  AnalyticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PipelineAnalytics>> getPipelineAnalytics() async {
    try {
      final response = await _remoteDataSource.getPipelineAnalytics();
      final apiResponse = ApiResponseModel<PipelineAnalytics>.fromJson(
        response,
        (data) =>
            PipelineAnalytics.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to get pipeline analytics'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<TimelineEntry>>> getTimelineData() async {
    try {
      final response = await _remoteDataSource.getTimelineData();
      final apiResponse = ApiResponseModel<List<TimelineEntry>>.fromJson(
        response,
        (data) => (data as List<dynamic>)
            .map((e) =>
                TimelineEntry.fromJson(e as Map<String, dynamic>))
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
