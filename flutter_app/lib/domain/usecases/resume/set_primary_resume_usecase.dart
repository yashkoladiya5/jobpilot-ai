import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';

@injectable
class SetPrimaryResumeUseCase {
  final ResumeRepository _repository;
  SetPrimaryResumeUseCase(this._repository);

  Future<Either<Failure, Resume>> call(String id) {
    return _repository.setPrimaryResume(id);
  }
}
