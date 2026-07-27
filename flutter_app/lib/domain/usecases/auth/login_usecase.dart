import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';
import 'package:jobpilot_ai/domain/repositories/auth_repository.dart';

/// UseCase encapsulating the login business logic.
/// Delegates the actual authentication process to the [AuthRepository].
@injectable
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) {
    return repository.login(email, password);
  }
}
