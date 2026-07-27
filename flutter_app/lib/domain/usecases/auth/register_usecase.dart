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

  Future<Either<Failure, User>> call(
      String email, String password, String name) {
    return repository.register(email, password, name);
  }
}
