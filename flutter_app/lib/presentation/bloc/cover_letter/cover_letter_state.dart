import 'package:jobpilot_ai/domain/entities/cover_letter.dart';

sealed class CoverLetterState {}

class CoverLetterInitial extends CoverLetterState {}

class CoverLetterGenerating extends CoverLetterState {}

class CoverLetterLoaded extends CoverLetterState {
  final CoverLetter coverLetter;
  CoverLetterLoaded(this.coverLetter);
}

class CoverLettersLoaded extends CoverLetterState {
  final List<CoverLetter> coverLetters;
  CoverLettersLoaded(this.coverLetters);
}

class CoverLetterError extends CoverLetterState {
  final String message;
  CoverLetterError(this.message);
}
