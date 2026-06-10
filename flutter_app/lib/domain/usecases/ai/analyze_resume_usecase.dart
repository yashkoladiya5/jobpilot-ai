import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class AnalyzeResumeUseCase {
  final AiRepository repository;

  AnalyzeResumeUseCase(this.repository);

  Future<Either<Failure, ResumeAnalysis>> call(String resumeId) {
    return repository.analyzeResume(resumeId);
  }
}
