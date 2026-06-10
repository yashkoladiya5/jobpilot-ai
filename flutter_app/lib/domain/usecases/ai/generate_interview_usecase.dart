import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GenerateInterviewUseCase {
  final AiRepository repository;

  GenerateInterviewUseCase(this.repository);

  Future<Either<Failure, InterviewSession>> call(String jobId) {
    return repository.generateInterviewQuestions(jobId);
  }
}
