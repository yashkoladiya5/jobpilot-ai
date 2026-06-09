import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;
  late final FlutterSecureStorage _storage;

  DioClient() {
    _storage = const FlutterSecureStorage();
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> upload<T>(
    String path, {
    required FormData data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      options: options ??
          Options(
            contentType: 'multipart/form-data',
          ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  _AuthInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConstants.authTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    developer.log('[HTTP] --> ${options.method} ${options.path}');
    if (options.data != null) {
      developer.log('[HTTP] Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    developer.log('[HTTP] <-- ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    developer.log('[HTTP] ERROR: ${err.type} - ${err.message}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(
              message: 'Connection timed out. Please try again.',
            ),
          ),
        );
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final message = (err.response?.data is Map
                ? (err.response?.data as Map)['message']
                : null) as String? ??
            'An unexpected error occurred';
        switch (statusCode) {
          case 401:
            handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: AuthException(message: message, statusCode: statusCode),
              ),
            );
          case 404:
            handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error:
                    ServerException(message: message, statusCode: statusCode),
              ),
            );
          case 422:
            handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: ValidationException(
                    message: message, statusCode: statusCode),
              ),
            );
          case 500:
            handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: ServerException(
                  message: 'Internal server error. Please try again later.',
                  statusCode: statusCode,
                ),
              ),
            );
          default:
            handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error:
                    ServerException(message: message, statusCode: statusCode),
              ),
            );
        }
      case DioExceptionType.cancel:
        handler.next(err);
      case DioExceptionType.unknown:
        if (err.message?.contains('SocketException') ?? false) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
                error: const NetworkException(
                  message: 'No internet connection. Please check your network.',
                ),
            ),
          );
        } else {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: const NetworkException(
                message: 'Network error occurred. Please try again.',
              ),
            ),
          );
        }
      default:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(
              message: 'Network error occurred. Please try again.',
            ),
          ),
        );
    }
  }
}
