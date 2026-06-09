import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/data/datasources/remote/resume_remote_datasource.dart';
import 'package:jobpilot_ai/data/models/api_response_model.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';

@LazySingleton(as: ResumeRepository)
class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeRemoteDataSource _remoteDataSource;

  ResumeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Resume>>> getResumes() async {
    try {
      final response = await _remoteDataSource.getResumes();
      final apiResponse = ApiResponseModel<List<Resume>>.fromJson(
        response,
        (data) => (data as List<dynamic>)
            .map((e) => Resume.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return Right(apiResponse.data ?? []);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> uploadResume(String filePath) async {
    try {
      final response = await _remoteDataSource.uploadResume(filePath);
      final apiResponse = ApiResponseModel<Resume>.fromJson(
        response,
        (data) => Resume.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(Failure.serverFailure(message: 'Failed to upload resume'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResume(String id) async {
    try {
      await _remoteDataSource.deleteResume(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, Resume>> setPrimaryResume(String id) async {
    try {
      final response = await _remoteDataSource.setPrimaryResume(id);
      final apiResponse = ApiResponseModel<Resume>.fromJson(
        response,
        (data) => Resume.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(
            Failure.serverFailure(message: 'Failed to set primary resume'));
      }
      return Right(apiResponse.data!);
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
