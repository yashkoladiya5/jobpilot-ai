import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/exceptions.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';

void main() {
  group('Core Exceptions & Failures Tests', () {
    test('ServerException toString formats message and statusCode correctly', () {
      const exWithCode = ServerException(message: 'Internal error', statusCode: 500);
      expect(exWithCode.toString(), equals('ServerException: Internal error (statusCode: 500)'));

      const exWithoutCode = ServerException(message: 'Unknown error');
      expect(exWithoutCode.toString(), equals('ServerException: Unknown error (statusCode: null)'));
    });

    test('NetworkException and AuthException toString formats as expected', () {
      const netEx = NetworkException(message: 'Connection timed out', statusCode: 408);
      expect(netEx.toString(), contains('NetworkException: Connection timed out'));

      const authEx = AuthException(message: 'Token expired', statusCode: 401);
      expect(authEx.toString(), contains('AuthException: Token expired'));
    });

    test('Failure union instances expose message and code accurately', () {
      const failure = Failure.authFailure(message: 'Unauthorized access', code: 401);
      expect(failure.message, equals('Unauthorized access'));
      expect(failure.code, equals(401));

      final resolved = failure.maybeWhen(
        authFailure: (msg, _) => 'auth: $msg',
        orElse: () => 'other',
      );

      expect(resolved, equals('auth: Unauthorized access'));
    });
  });
}
