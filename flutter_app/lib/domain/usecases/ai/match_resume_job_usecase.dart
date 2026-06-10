import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class MatchResumeJobUseCase {
  final AiRepository repository;

  MatchResumeJobUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      String resumeId, String jobDescription) {
    return repository.matchResumeAndJob(resumeId, jobDescription);
  }
}
