import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_match_event.freezed.dart';

@freezed
sealed class AiMatchEvent with _$AiMatchEvent {
  const factory AiMatchEvent.loadMatches() = LoadMatches;

  const factory AiMatchEvent.matchResumeToJob(
    String resumeId,
    String jobDescription,
  ) = MatchResumeToJob;
}
