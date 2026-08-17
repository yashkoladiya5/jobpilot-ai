import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';
import 'package:jobpilot_ai/domain/repositories/auth_repository.dart';

/// UseCase encapsulating the user registration business logic.
/// Delegates account creation to the [AuthRepository].
@injectable
class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  /// Executes the registration operation.
  Future<Either<Failure, User>> call(
      String email, String password, String name) async {
    // Fail fast on invalid inputs before propagating to remote datasource
    if (email.trim().isEmpty || !email.contains('@')) {
      return const Left(Failure.validationFailure(message: 'Please provide a valid email address'));
    }
    if (password.length < 6) {
      return const Left(Failure.validationFailure(message: 'Password must be at least 6 characters long'));
    }
    if (name.trim().isEmpty) {
      return const Left(Failure.validationFailure(message: 'Name cannot be empty'));
    }
      
    return repository.register(email, password, name);
  }
}
