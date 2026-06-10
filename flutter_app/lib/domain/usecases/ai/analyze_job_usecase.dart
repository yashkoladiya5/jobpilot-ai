import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class AnalyzeJobUseCase {
  final AiRepository repository;

  AnalyzeJobUseCase(this.repository);

  Future<Either<Failure, JobAnalysis>> call(String jobDescription,
      {String? jobId}) {
    return repository.analyzeJobDescription(jobDescription, jobId: jobId);
  }
}
