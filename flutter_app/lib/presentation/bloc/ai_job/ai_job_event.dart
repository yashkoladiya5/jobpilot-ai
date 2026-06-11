import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_job_event.freezed.dart';

@freezed
sealed class AiJobEvent with _$AiJobEvent {
  const factory AiJobEvent.loadJobAnalyses() = LoadJobAnalyses;

  const factory AiJobEvent.analyzeJobDescription(String description) =
      AnalyzeJobDescription;

  const factory AiJobEvent.loadJobAnalysis(String analysisId) = LoadJobAnalysis;

  const factory AiJobEvent.loadAllJobAnalyses() = LoadAllJobAnalyses;
}
