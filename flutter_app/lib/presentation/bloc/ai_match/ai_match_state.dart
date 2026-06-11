import 'package:jobpilot_ai/domain/entities/match_result.dart';

sealed class AiMatchState {}

class AiMatchInitial extends AiMatchState {}

class AiMatchMatching extends AiMatchState {}

class AiMatchLoaded extends AiMatchState {
  final MatchResult result;
  AiMatchLoaded(this.result);
}

class AiMatchError extends AiMatchState {
  final String message;
  AiMatchError(this.message);
}
