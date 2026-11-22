import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/dio_error_mapper.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';

void main() {
  group('mapDioError Unit Tests', () {
    final dummyRequestOptions = RequestOptions(path: '/api/test');

    test('maps AuthException to Failure.authFailure', () {
      final dioException = DioException(
        requestOptions: dummyRequestOptions,
        error: const AuthException(message: 'Invalid auth token', statusCode: 401),
      );

      final failure = mapDioError(dioException);

      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).message, equals('Invalid auth token'));
      expect(failure.code, equals(401));
    });

    test('maps ServerException to Failure.serverFailure', () {
      final dioException = DioException(
        requestOptions: dummyRequestOptions,
        error: const ServerException(message: 'Database unavailable', statusCode: 503),
      );

      final failure = mapDioError(dioException);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).message, equals('Database unavailable'));
      expect(failure.code, equals(503));
    });

    test('maps NetworkException to Failure.networkFailure', () {
      final dioException = DioException(
        requestOptions: dummyRequestOptions,
        error: const NetworkException(message: 'No internet connectivity', statusCode: 0),
      );

      final failure = mapDioError(dioException);

      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).message, equals('No internet connectivity'));
    });

    test('maps ValidationException to Failure.validationFailure', () {
      final dioException = DioException(
        requestOptions: dummyRequestOptions,
        error: const ValidationException(message: 'Email is invalid', statusCode: 422),
      );

      final failure = mapDioError(dioException);

      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).message, equals('Email is invalid'));
      expect(failure.code, equals(422));
    });

    test('extracts backend message from response envelope data', () {
      final dioException = DioException(
        requestOptions: dummyRequestOptions,
        response: Response(
          requestOptions: dummyRequestOptions,
          statusCode: 400,
          data: {
            'success': false,
            'message': 'User already registered with this email',
          },
        ),
      );

      final failure = mapDioError(dioException);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).message, equals('User already registered with this email'));
    });
  });
}
