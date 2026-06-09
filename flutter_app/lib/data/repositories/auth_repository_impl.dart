import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/data/datasources/local/auth_local_datasource.dart';
import 'package:jobpilot_ai/data/datasources/remote/auth_remote_datasource.dart';
import 'package:jobpilot_ai/data/models/api_response_model.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';
import 'package:jobpilot_ai/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response,
        (data) => data as Map<String, dynamic>,
      );
      final data = apiResponse.data;
      if (data == null) {
        return const Left(Failure.serverFailure(message: 'No data returned'));
      }
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      final token = data['token'] as String;
      await _localDataSource.saveToken(token);
      await _localDataSource.saveUserData(jsonEncode(user.toJson()));
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, User>> register(
      String email, String password, String name) async {
    try {
      final response = await _remoteDataSource.register(email, password, name);
      final apiResponse = ApiResponseModel<Map<String, dynamic>>.fromJson(
        response,
        (data) => data as Map<String, dynamic>,
      );
      final data = apiResponse.data;
      if (data == null) {
        return const Left(Failure.serverFailure(message: 'No data returned'));
      }
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      final token = data['token'] as String;
      await _localDataSource.saveToken(token);
      await _localDataSource.saveUserData(jsonEncode(user.toJson()));
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    try {
      final response = await _remoteDataSource.getMe();
      final apiResponse = ApiResponseModel<User>.fromJson(
        response,
        (data) => User.fromJson(data as Map<String, dynamic>),
      );
      final user = apiResponse.data;
      if (user == null) {
        return const Left(Failure.serverFailure(message: 'No user data returned'));
      }
      await _localDataSource.saveUserData(jsonEncode(user.toJson()));
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.deleteToken();
      await _localDataSource.deleteUserData();
      return const Right(null);
    } catch (e) {
      return const Left(Failure.cacheFailure(message: 'Failed to clear session data'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _localDataSource.isAuthenticated();
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
