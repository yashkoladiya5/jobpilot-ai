import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GetInterviewSessionsUseCase {
  final AiRepository repository;

  GetInterviewSessionsUseCase(this.repository);

  Future<Either<Failure, List<InterviewSession>>> call() {
    return repository.getInterviewSessions();
  }
}
