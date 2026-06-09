import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';

part 'resume_state.freezed.dart';

@freezed
sealed class ResumeState with _$ResumeState {
  const factory ResumeState.initial() = ResumeInitial;

  const factory ResumeState.loading() = ResumeLoading;

  const factory ResumeState.resumesLoaded(List<Resume> resumes) = ResumesLoaded;

  const factory ResumeState.uploadSuccess(Resume resume) = UploadSuccess;

  const factory ResumeState.operationSuccess(String message) = ResumeOperationSuccess;

  const factory ResumeState.error(String message) = ResumeError;
}
