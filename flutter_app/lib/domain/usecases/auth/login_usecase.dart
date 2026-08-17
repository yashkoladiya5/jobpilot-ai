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

  /// Executes the login operation with email and password.
  Future<Either<Failure, User>> call(String email, String password) async {
    // Fail fast on empty credentials before hitting the network layer
    if (email.trim().isEmpty) {
      return const Left(Failure.validationFailure(message: 'Email address cannot be empty'));
    }
    if (password.isEmpty) {
      return const Left(Failure.validationFailure(message: 'Password cannot be empty'));
    }
    
    return repository.login(email, password);
  }
}
