import 'package:freezed_annotation/freezed_annotation.dart';

part 'cover_letter_event.freezed.dart';

@freezed
sealed class CoverLetterEvent with _$CoverLetterEvent {
  const factory CoverLetterEvent.generateCoverLetter(
    String resumeId,
    String jobDescription, {
    String? jobId,
    String? tone,
  }) = GenerateCoverLetter;

  const factory CoverLetterEvent.loadCoverLetters() = LoadCoverLetters;

  const factory CoverLetterEvent.loadCoverLetter(String id) = LoadCoverLetter;
}
