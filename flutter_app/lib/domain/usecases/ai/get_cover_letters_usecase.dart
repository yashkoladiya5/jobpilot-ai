import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/cover_letter.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GetCoverLettersUseCase {
  final AiRepository repository;

  GetCoverLettersUseCase(this.repository);

  Future<Either<Failure, List<CoverLetter>>> call() {
    return repository.getCoverLetters();
  }
}
