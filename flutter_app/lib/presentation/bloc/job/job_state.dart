import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';

part 'job_state.freezed.dart';

@freezed
sealed class JobState with _$JobState {
  const factory JobState.initial() = JobInitial;
  const factory JobState.loading() = JobLoading;
  const factory JobState.jobsLoaded(List<JobApplication> jobs) = JobsLoaded;
  const factory JobState.jobDetailLoaded(JobApplication job) = JobDetailLoaded;
  const factory JobState.operationSuccess(String message) = JobOperationSuccess;
  const factory JobState.error(String message) = JobError;
}
