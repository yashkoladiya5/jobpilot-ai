import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_match/ai_match_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_match/ai_match_state.dart';

@injectable
class AiMatchBloc extends Bloc<AiMatchEvent, AiMatchState> {
  AiMatchBloc() : super(AiMatchInitial()) {
    on<LoadMatches>(_onLoadMatches);
    on<MatchResumeToJob>(_onMatch);
  }

  Future<void> _onLoadMatches(
    LoadMatches event,
    Emitter<AiMatchState> emit,
  ) async {
    emit(AiMatchMatching());
  }

  Future<void> _onMatch(
    MatchResumeToJob event,
    Emitter<AiMatchState> emit,
  ) async {}
}
