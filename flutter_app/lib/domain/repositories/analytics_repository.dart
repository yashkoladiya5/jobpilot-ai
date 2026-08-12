import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';

/// Abstract definition of the Analytics Repository.
/// Provides metrics on application pipeline and historical timeline data.
abstract class AnalyticsRepository {
  Future<Either<Failure, PipelineAnalytics>> getPipelineAnalytics();
  Future<Either<Failure, List<TimelineEntry>>> getTimelineData();
  Future<Either<Failure, void>> refreshAnalyticsData();
}
