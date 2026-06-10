import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';

@injectable
class GetCareerInsightsHistoryUseCase {
  final AiRepository repository;

  GetCareerInsightsHistoryUseCase(this.repository);

  Future<Either<Failure, List<CareerInsight>>> call() {
    return repository.getCareerInsightsHistory();
  }
}
