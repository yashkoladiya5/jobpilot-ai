import 'package:freezed_annotation/freezed_annotation.dart';

part 'career_insights_event.freezed.dart';

@freezed
sealed class CareerInsightsEvent with _$CareerInsightsEvent {
  const factory CareerInsightsEvent.loadCareerInsights() = LoadCareerInsights;

  const factory CareerInsightsEvent.refreshCareerInsights() =
      RefreshCareerInsights;
}
