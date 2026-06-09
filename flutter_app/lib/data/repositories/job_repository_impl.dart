import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/data/datasources/remote/job_remote_datasource.dart';
import 'package:jobpilot_ai/data/models/api_response_model.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/domain/repositories/job_repository.dart';

@LazySingleton(as: JobRepository)
class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource _remoteDataSource;

  JobRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<JobApplication>>> getJobs() async {
    try {
      final response = await _remoteDataSource.getJobs();
      final apiResponse = ApiResponseModel<List<JobApplication>>.fromJson(
        response,
        (data) => (data as List<dynamic>)
            .map((e) =>
                JobApplication.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return Right(apiResponse.data ?? []);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, JobApplication>> getJobById(String id) async {
    try {
      final response = await _remoteDataSource.getJobById(id);
      final apiResponse = ApiResponseModel<JobApplication>.fromJson(
        response,
        (data) =>
            JobApplication.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(Failure.serverFailure(message: 'Job not found'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, JobApplication>> createJob(
      CreateJobParams params) async {
    try {
      final data = {
        'companyName': params.companyName,
        'role': params.role,
        if (params.jobUrl != null) 'jobUrl': params.jobUrl,
        if (params.salaryRange != null) 'salaryRange': params.salaryRange,
        if (params.location != null) 'location': params.location,
        if (params.status != null) 'status': params.status!.value,
        if (params.notes != null) 'notes': params.notes,
        if (params.resumeId != null) 'resumeId': params.resumeId,
        if (params.appliedDate != null)
          'appliedDate': params.appliedDate!.toIso8601String(),
      };
      final response = await _remoteDataSource.createJob(data);
      final apiResponse = ApiResponseModel<JobApplication>.fromJson(
        response,
        (data) =>
            JobApplication.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(Failure.serverFailure(message: 'Failed to create job'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, JobApplication>> updateJob(
      String id, UpdateJobParams params) async {
    try {
      final data = <String, dynamic>{
        if (params.companyName != null) 'companyName': params.companyName,
        if (params.role != null) 'role': params.role,
        if (params.jobUrl != null) 'jobUrl': params.jobUrl,
        if (params.salaryRange != null) 'salaryRange': params.salaryRange,
        if (params.location != null) 'location': params.location,
        if (params.status != null) 'status': params.status!.value,
        if (params.notes != null) 'notes': params.notes,
        if (params.resumeId != null) 'resumeId': params.resumeId,
        if (params.appliedDate != null)
          'appliedDate': params.appliedDate!.toIso8601String(),
      };
      final response = await _remoteDataSource.updateJob(id, data);
      final apiResponse = ApiResponseModel<JobApplication>.fromJson(
        response,
        (data) =>
            JobApplication.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.data == null) {
        return const Left(Failure.serverFailure(message: 'Failed to update job'));
      }
      return Right(apiResponse.data!);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJob(String id) async {
    try {
      await _remoteDataSource.deleteJob(id);
      return const Right(null);
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
