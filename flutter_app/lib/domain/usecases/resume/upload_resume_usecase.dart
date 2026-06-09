import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadResumeUseCase {
  final ResumeRepository repository;
  UploadResumeUseCase(this.repository);

  Future<Either<Failure, Resume>> call(String filePath) {
    return repository.uploadResume(filePath);
  }
}
