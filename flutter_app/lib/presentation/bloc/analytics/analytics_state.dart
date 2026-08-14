import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';

sealed class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final PipelineAnalytics analytics;
  final List<TimelineEntry>? timeline;
  final bool isRefreshing;

  AnalyticsLoaded({
    required this.analytics,
    this.timeline,
    this.isRefreshing = false,
  });

  AnalyticsLoaded copyWith({
    PipelineAnalytics? analytics,
    List<TimelineEntry>? timeline,
    bool? isRefreshing,
  }) {
    return AnalyticsLoaded(
      analytics: analytics ?? this.analytics,
      timeline: timeline ?? this.timeline,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class AnalyticsError extends AnalyticsState {
  final String message;

  AnalyticsError(this.message);
}
