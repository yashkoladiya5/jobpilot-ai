import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_state.dart';

@injectable
class AiResumeBloc extends Bloc<AiResumeEvent, AiResumeState> {
  AiResumeBloc() : super(AiResumeInitial()) {
    on<LoadResumeAnalyses>(_onLoadResumeAnalyses);
    on<LoadResumeAnalysis>(_onLoadAnalysis);
    on<LoadAllResumeAnalyses>(_onLoadAll);
    on<AnalyzeResume>(_onAnalyze);
  }

  Future<void> _onLoadResumeAnalyses(
    LoadResumeAnalyses event,
    Emitter<AiResumeState> emit,
  ) async {
    emit(AiResumeAnalyzing());
  }

  Future<void> _onLoadAnalysis(
    LoadResumeAnalysis event,
    Emitter<AiResumeState> emit,
  ) async {}

  Future<void> _onLoadAll(
    LoadAllResumeAnalyses event,
    Emitter<AiResumeState> emit,
  ) async {}

  Future<void> _onAnalyze(
    AnalyzeResume event,
    Emitter<AiResumeState> emit,
  ) async {}
}
