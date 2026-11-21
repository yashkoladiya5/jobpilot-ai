import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';
import 'package:jobpilot_ai/domain/repositories/auth_repository.dart';
import 'package:jobpilot_ai/domain/usecases/auth/login_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/auth/register_usecase.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (email == 'valid@jobpilot.ai' && password == 'Secret123!') {
      return const Right(
        User(id: 'u1', email: 'valid@jobpilot.ai', name: 'Valid User'),
      );
    }
    return const Left(Failure.authFailure(message: 'Invalid credentials'));
  }

  @override
  Future<Either<Failure, User>> register(
      String email, String password, String name) async {
    return Right(
      User(id: 'u2', email: email, name: name),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    return const Right(
      User(id: 'u1', email: 'valid@jobpilot.ai', name: 'Valid User'),
    );
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    return const Right(
      User(id: 'u1', email: 'valid@jobpilot.ai', name: 'Valid User'),
    );
  }

  @override
  Future<bool> isAuthenticated() async => true;
}

void main() {
  late MockAuthRepository mockRepo;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepo);
    registerUseCase = RegisterUseCase(mockRepo);
  });

  group('LoginUseCase Unit Tests', () {
    test('returns ValidationFailure on empty email without invoking repo', () async {
      final result = await loginUseCase('', 'password');
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('Email address cannot be empty')),
        (_) => fail('Should not succeed'),
      );
    });

    test('returns ValidationFailure on empty password without invoking repo', () async {
      final result = await loginUseCase('user@test.com', '');
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('Password cannot be empty')),
        (_) => fail('Should not succeed'),
      );
    });

    test('returns User on valid credentials', () async {
      final result = await loginUseCase('valid@jobpilot.ai', 'Secret123!');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should not fail'),
        (user) => expect(user.email, equals('valid@jobpilot.ai')),
      );
    });
  });

  group('RegisterUseCase Unit Tests', () {
    test('returns ValidationFailure on invalid email or short password', () async {
      final res1 = await registerUseCase('not-an-email', '12345678', 'Alex');
      expect(res1.isLeft(), isTrue);

      final res2 = await registerUseCase('user@test.com', '123', 'Alex');
      expect(res2.isLeft(), isTrue);

      final res3 = await registerUseCase('user@test.com', '12345678', '   ');
      expect(res3.isLeft(), isTrue);
    });

    test('returns User when input criteria are satisfied', () async {
      final result = await registerUseCase('newuser@domain.com', 'ValidP@ss123', 'Jordan');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should not fail'),
        (user) {
          expect(user.name, equals('Jordan'));
          expect(user.email, equals('newuser@domain.com'));
        },
      );
    });
  });
}
