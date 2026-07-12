import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/cover_letter.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GenerateCoverLetterUseCase {
  final AiRepository repository;

  GenerateCoverLetterUseCase(this.repository);

  Future<Either<Failure, CoverLetter>> call(
    String resumeId,
    String jobDescription, {
    String? jobId,
    String? tone,
  }) {
    return repository.generateCoverLetter(
      resumeId,
      jobDescription,
      jobId: jobId,
      tone: tone,
    );
  }
}
