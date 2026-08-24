class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException({required this.message, this.statusCode});

  @override
  String toString() => 'NetworkException: $message (statusCode: $statusCode)';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({required this.message, this.statusCode});

  @override
  String toString() => 'AuthException: $message (statusCode: $statusCode)';
}

class ValidationException implements Exception {
  final String message;
  final int? statusCode;

  const ValidationException({required this.message, this.statusCode});

  @override
  String toString() => 'ValidationException: $message (statusCode: $statusCode)';
}

class CacheException implements Exception {
  final String message;
  final int? statusCode;

  const CacheException({required this.message, this.statusCode});

  @override
  String toString() => 'CacheException: $message (statusCode: $statusCode)';
}

class AiProcessingException implements Exception {
  final String message;
  final int? statusCode;
  final String? modelError;

  const AiProcessingException({
    required this.message, 
    this.statusCode,
    this.modelError,
  });

  @override
  String toString() => 'AiProcessingException: $message (statusCode: $statusCode, modelError: $modelError)';
}

class TimeoutException implements Exception {
  final String message;
  final int? statusCode;

  const TimeoutException({required this.message, this.statusCode});

  @override
  String toString() => 'TimeoutException: $message (statusCode: $statusCode)';
}

class PermissionException implements Exception {
  final String message;
  final int? statusCode;

  const PermissionException({required this.message, this.statusCode});

  @override
  String toString() => 'PermissionException: $message (statusCode: $statusCode)';
}

class RateLimitException implements Exception {
  final String message;
  final int? statusCode;

  const RateLimitException({required this.message, this.statusCode});

  @override
  String toString() => 'RateLimitException: $message (statusCode: $statusCode)';
}
