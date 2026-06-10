import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';

sealed class AiResumeState {}

class AiResumeInitial extends AiResumeState {}

class AiResumeAnalyzing extends AiResumeState {}

class AiResumeLoaded extends AiResumeState {
  final ResumeAnalysis analysis;
  AiResumeLoaded(this.analysis);
}

class AiResumeAnalysesLoaded extends AiResumeState {
  final List<ResumeAnalysis> analyses;
  AiResumeAnalysesLoaded(this.analyses);
}

class AiResumeError extends AiResumeState {
  final String message;
  AiResumeError(this.message);
}
