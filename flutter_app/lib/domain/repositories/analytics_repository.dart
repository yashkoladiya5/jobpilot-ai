import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, PipelineAnalytics>> getPipelineAnalytics();
  Future<Either<Failure, List<TimelineEntry>>> getTimelineData();
}
