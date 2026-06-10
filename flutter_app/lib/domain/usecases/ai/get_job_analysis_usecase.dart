import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GetJobAnalysisUseCase {
  final AiRepository repository;

  GetJobAnalysisUseCase(this.repository);

  Future<Either<Failure, JobAnalysis>> call(String analysisId) {
    return repository.getJobAnalysis(analysisId);
  }
}
