import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';
import 'package:jobpilot_ai/domain/repositories/analytics_repository.dart';

@injectable
class GetTimelineDataUseCase {
  final AnalyticsRepository repository;

  GetTimelineDataUseCase(this.repository);

  Future<Either<Failure, List<TimelineEntry>>> call() {
    return repository.getTimelineData();
  }
}
