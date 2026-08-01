import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';

/// Abstract definition of the Resume Repository.
/// Manages uploading, deleting, and setting the primary resume file.
abstract class ResumeRepository {
  /// Fetches a list of all resumes uploaded by the current user.
  Future<Either<Failure, List<Resume>>> getResumes();
  Future<Either<Failure, Resume>> uploadResume(String filePath);
  Future<Either<Failure, void>> deleteResume(String id);
  Future<Either<Failure, Resume>> setPrimaryResume(String id);
}
