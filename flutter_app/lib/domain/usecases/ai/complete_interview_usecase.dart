import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/interview_result.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class CompleteInterviewUseCase {
  final AiRepository repository;

  CompleteInterviewUseCase(this.repository);

  Future<Either<Failure, InterviewResult>> call(String sessionId) {
    return repository.completeInterview(sessionId);
  }
}
