import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Maps a [DioException] whose embedded error is a domain exception
/// (or none) to the corresponding [Failure].
Failure mapDioError(
  DioException e, {
  String fallbackMessage = 'An unexpected error occurred',
}) {
  if (e.error is AuthException) {
    return Failure.authFailure(
      message: (e.error as AuthException).message,
      code: (e.error as AuthException).statusCode,
    );
  }
  if (e.error is ServerException) {
    return Failure.serverFailure(
      message: (e.error as ServerException).message,
      code: (e.error as ServerException).statusCode,
    );
  }
  if (e.error is NetworkException) {
    return Failure.networkFailure(
      message: (e.error as NetworkException).message,
      code: (e.error as NetworkException).statusCode,
    );
  }
  if (e.error is ValidationException) {
    return Failure.validationFailure(
      message: (e.error as ValidationException).message,
      code: (e.error as ValidationException).statusCode,
    );
  }
  if (e.error is CacheException) {
    return Failure.cacheFailure(
      message: (e.error as CacheException).message,
      code: (e.error as CacheException).statusCode,
    );
  }
  if (e.error is TimeoutException) {
    return Failure.timeoutFailure(
      message: (e.error as TimeoutException).message,
      code: (e.error as TimeoutException).statusCode,
    );
  }
  return Failure.serverFailure(
    message: e.message ?? fallbackMessage,
  );
}