import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';

sealed class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final PipelineAnalytics analytics;
  final List<TimelineEntry>? timeline;

  AnalyticsLoaded({required this.analytics, this.timeline});
}

class AnalyticsError extends AnalyticsState {
  final String message;

  AnalyticsError(this.message);
}
