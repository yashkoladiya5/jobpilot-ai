import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';

/// Abstract definition of the Authentication Repository.
/// Handles login, registration, session checks, and logout.
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(
      String email, String password, String name);
  Future<Either<Failure, User>> getMe();
  Future<Either<Failure, void>> logout();
  Future<bool> isAuthenticated();
}
