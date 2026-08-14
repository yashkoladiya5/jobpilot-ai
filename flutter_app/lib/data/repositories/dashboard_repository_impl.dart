import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:jobpilot_ai/data/models/api_response_model.dart';
import 'package:jobpilot_ai/domain/entities/dashboard_stats.dart';
import 'package:jobpilot_ai/domain/repositories/dashboard_repository.dart';

/// Concrete implementation of the DashboardRepository.
/// Fetches statistics from the remote API and maps them to domain entities.
@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  DashboardStats? _cachedStats;
  DateTime? _lastFetchTime;
  static const _cacheDuration = Duration(minutes: 5);

  @override
  Future<Either<Failure, DashboardStats>> getStats() async {
    // Check if we have a valid cached version first to save network calls
    if (_cachedStats != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        return Right(_cachedStats!);
      }
    }
    
    try {
      final response = await _remoteDataSource.getStats();
      final apiResponse = ApiResponseModel<DashboardStats>.fromJson(
        response,
        (data) =>
            DashboardStats.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(Failure.serverFailure(message: 'No stats data returned'));
      }
      
      // Update the cache on successful fetch
      _cachedStats = apiResponse.data!;
      _lastFetchTime = DateTime.now();
      
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  /// Manually clear the cache to force a fresh fetch on the next request.
  void clearCache() {
    _cachedStats = null;
    _lastFetchTime = null;
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
