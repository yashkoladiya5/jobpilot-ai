import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/dio_error_mapper.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/data/datasources/remote/resume_remote_datasource.dart';
import 'package:jobpilot_ai/data/models/api_response_model.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';

/// Concrete implementation of the ResumeRepository.
/// Uploads and manages resume files via the remote API.
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
      return Left(mapDioError(e));
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
      return Left(mapDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResume(String id) async {
    try {
      await _remoteDataSource.deleteResume(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioError(e));
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
      return Left(mapDioError(e));
    }
  }
}
