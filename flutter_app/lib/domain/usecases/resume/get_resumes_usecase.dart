import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';

@injectable
class GetResumesUseCase {
  final ResumeRepository repository;
  GetResumesUseCase(this.repository);

  Future<Either<Failure, List<Resume>>> call() {
    return repository.getResumes();
  }
}
