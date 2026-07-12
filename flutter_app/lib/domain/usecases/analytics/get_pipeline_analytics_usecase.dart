import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';
import 'package:jobpilot_ai/domain/repositories/analytics_repository.dart';

@injectable
class GetPipelineAnalyticsUseCase {
  final AnalyticsRepository repository;

  GetPipelineAnalyticsUseCase(this.repository);

  Future<Either<Failure, PipelineAnalytics>> call() {
    return repository.getPipelineAnalytics();
  }
}
