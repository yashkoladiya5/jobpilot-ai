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
  // Prefer the backend's human-readable message (which the error handler and
  // validation middleware place in the `{ success, message, ... }` envelope)
  // over the generic dio-derived message, so users see the real explanation.
  final backendMessage = _backendMessage(e);
  return Failure.serverFailure(
    message: backendMessage ?? e.message ?? fallbackMessage,
  );
}

/// Extracts the human-readable `message` the backend included in its error
/// envelope, returning null when absent or malformed so callers fall back to
/// the generic dio message.
String? _backendMessage(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }
  }
  return null;
}