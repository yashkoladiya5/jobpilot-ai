import 'package:jobpilot_ai/domain/entities/job_analysis.dart';

sealed class AiJobState {}

class AiJobInitial extends AiJobState {}

class AiJobAnalyzing extends AiJobState {}

class AiJobLoaded extends AiJobState {
  final JobAnalysis analysis;
  AiJobLoaded(this.analysis);
}

class AiJobAnalysesLoaded extends AiJobState {
  final List<JobAnalysis> analyses;
  AiJobAnalysesLoaded(this.analyses);
}

class AiJobError extends AiJobState {
  final String message;
  AiJobError(this.message);
}
