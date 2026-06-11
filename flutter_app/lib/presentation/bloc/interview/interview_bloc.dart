import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_event.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_state.dart';

@injectable
class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  InterviewBloc() : super(InterviewInitial()) {
    on<LoadInterviewSessions>(_onLoadSessions);
    on<LoadInterviewSession>(_onLoadSession);
    on<GenerateInterview>(_onGenerate);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<CompleteInterview>(_onComplete);
    on<LoadInterviewResult>(_onLoadResult);
  }

  Future<void> _onLoadSessions(
    LoadInterviewSessions event,
    Emitter<InterviewState> emit,
  ) async {}

  Future<void> _onLoadSession(
    LoadInterviewSession event,
    Emitter<InterviewState> emit,
  ) async {}

  Future<void> _onGenerate(
    GenerateInterview event,
    Emitter<InterviewState> emit,
  ) async {}

  Future<void> _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<InterviewState> emit,
  ) async {}

  Future<void> _onComplete(
    CompleteInterview event,
    Emitter<InterviewState> emit,
  ) async {}

  Future<void> _onLoadResult(
    LoadInterviewResult event,
    Emitter<InterviewState> emit,
  ) async {}
}
