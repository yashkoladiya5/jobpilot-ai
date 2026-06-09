import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_event.freezed.dart';

@freezed
sealed class ResumeEvent with _$ResumeEvent {
  const factory ResumeEvent.loadResumes() = LoadResumes;

  const factory ResumeEvent.uploadResume(String filePath) = UploadResume;

  const factory ResumeEvent.deleteResume(String id) = DeleteResume;

  const factory ResumeEvent.setPrimaryResume(String id) = SetPrimaryResume;
}
