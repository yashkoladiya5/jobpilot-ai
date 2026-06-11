import 'package:jobpilot_ai/domain/entities/career_insight.dart';

sealed class CareerInsightsState {}

class CareerInsightsInitial extends CareerInsightsState {}

class CareerInsightsLoading extends CareerInsightsState {}

class CareerInsightsLoaded extends CareerInsightsState {
  final CareerInsight insight;
  CareerInsightsLoaded(this.insight);
}

class CareerInsightsError extends CareerInsightsState {
  final String message;
  CareerInsightsError(this.message);
}
