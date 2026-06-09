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
