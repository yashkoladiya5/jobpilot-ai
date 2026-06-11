import 'package:freezed_annotation/freezed_annotation.dart';

part 'interview_event.freezed.dart';

@freezed
sealed class InterviewEvent with _$InterviewEvent {
  const factory InterviewEvent.loadInterviewSessions() = LoadInterviewSessions;

  const factory InterviewEvent.loadInterviewSession(String sessionId) =
      LoadInterviewSession;

  const factory InterviewEvent.generateInterview(
    String companyName,
    String role,
  ) = GenerateInterview;

  const factory InterviewEvent.submitAnswer(
    String sessionId,
    String questionId,
    String answer,
  ) = SubmitAnswer;

  const factory InterviewEvent.completeInterview(String sessionId) =
      CompleteInterview;

  const factory InterviewEvent.loadInterviewResult(String sessionId) =
      LoadInterviewResult;
}
