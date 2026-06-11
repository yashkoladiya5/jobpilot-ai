import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class SubmitAnswerUseCase {
  final AiRepository repository;

  SubmitAnswerUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      String questionId, String answer) {
    return repository.submitAnswer(questionId, answer);
  }
}
