import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GetCareerInsightsUseCase {
  final AiRepository repository;

  GetCareerInsightsUseCase(this.repository);

  Future<Either<Failure, CareerInsight>> call() {
    return repository.getCareerInsights();
  }
}
