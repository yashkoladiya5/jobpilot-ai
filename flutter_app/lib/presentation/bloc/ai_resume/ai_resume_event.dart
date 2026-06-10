import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_resume_event.freezed.dart';

@freezed
sealed class AiResumeEvent with _$AiResumeEvent {
  const factory AiResumeEvent.loadResumeAnalyses() = LoadResumeAnalyses;

  const factory AiResumeEvent.loadResumeAnalysis(String resumeId) =
      LoadResumeAnalysis;

  const factory AiResumeEvent.loadAllResumeAnalyses() = LoadAllResumeAnalyses;

  const factory AiResumeEvent.analyzeResume(String resumeId) = AnalyzeResume;
}
