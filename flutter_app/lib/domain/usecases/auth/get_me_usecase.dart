import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';
import 'package:jobpilot_ai/domain/repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository repository;
  GetMeUseCase(this.repository);

  Future<Either<Failure, User>> call() {
    return repository.getMe();
  }
}
