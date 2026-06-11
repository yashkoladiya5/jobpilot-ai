import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_state.dart';

@injectable
class AiJobBloc extends Bloc<AiJobEvent, AiJobState> {
  AiJobBloc() : super(AiJobInitial()) {
    on<LoadJobAnalyses>(_onLoadJobAnalyses);
    on<AnalyzeJobDescription>(_onAnalyze);
    on<LoadJobAnalysis>(_onLoad);
    on<LoadAllJobAnalyses>(_onLoadAll);
  }

  Future<void> _onLoadJobAnalyses(
    LoadJobAnalyses event,
    Emitter<AiJobState> emit,
  ) async {
    emit(AiJobAnalyzing());
  }

  Future<void> _onAnalyze(
    AnalyzeJobDescription event,
    Emitter<AiJobState> emit,
  ) async {}

  Future<void> _onLoad(
    LoadJobAnalysis event,
    Emitter<AiJobState> emit,
  ) async {}

  Future<void> _onLoadAll(
    LoadAllJobAnalyses event,
    Emitter<AiJobState> emit,
  ) async {}
}
