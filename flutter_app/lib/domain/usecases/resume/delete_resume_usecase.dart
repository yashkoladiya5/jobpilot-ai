import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteResumeUseCase {
  final ResumeRepository repository;
  DeleteResumeUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteResume(id);
  }
}
