import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GetResumeAnalysesUseCase {
  final AiRepository repository;

  GetResumeAnalysesUseCase(this.repository);

  Future<Either<Failure, List<ResumeAnalysis>>> call() {
    return repository.getResumeAnalyses();
  }
}
