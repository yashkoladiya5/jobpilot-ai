import 'package:jobpilot_ai/domain/entities/interview_result.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';

sealed class InterviewState {}

class InterviewInitial extends InterviewState {}

class InterviewLoading extends InterviewState {}

class InterviewSessionsLoaded extends InterviewState {
  final List<InterviewSession> sessions;
  InterviewSessionsLoaded(this.sessions);
}

class InterviewSessionLoaded extends InterviewState {
  final InterviewSession session;
  InterviewSessionLoaded(this.session);
}

class InterviewAnswerSubmitting extends InterviewState {}

class InterviewResultLoaded extends InterviewState {
  final InterviewResult result;
  final InterviewSession session;
  InterviewResultLoaded(this.result, this.session);
}

class InterviewGenerated extends InterviewState {
  final InterviewSession session;
  InterviewGenerated(this.session);
}

class InterviewError extends InterviewState {
  final String message;
  InterviewError(this.message);
}
