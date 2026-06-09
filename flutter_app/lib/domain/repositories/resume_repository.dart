import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';

abstract class ResumeRepository {
  Future<Either<Failure, List<Resume>>> getResumes();
  Future<Either<Failure, Resume>> uploadResume(String filePath);
  Future<Either<Failure, void>> deleteResume(String id);
  Future<Either<Failure, Resume>> setPrimaryResume(String id);
}
