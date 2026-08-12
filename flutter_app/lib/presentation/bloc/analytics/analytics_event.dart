import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

/// Events related to the analytics dashboard.
@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent.loadPipelineAnalytics() =
      LoadPipelineAnalytics;
  const factory AnalyticsEvent.loadTimelineData() = LoadTimelineData;
  const factory AnalyticsEvent.refreshAll() = RefreshAllAnalytics;
}
