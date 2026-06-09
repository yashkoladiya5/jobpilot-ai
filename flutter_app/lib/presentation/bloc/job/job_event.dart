import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobpilot_ai/domain/repositories/job_repository.dart';

part 'job_event.freezed.dart';

@freezed
sealed class JobEvent with _$JobEvent {
  const factory JobEvent.loadJobs() = LoadJobs;
  const factory JobEvent.loadJobDetail(String id) = LoadJobDetail;
  const factory JobEvent.createJob(CreateJobParams params) = CreateJob;
  const factory JobEvent.updateJob(String id, UpdateJobParams params) =
      UpdateJob;
  const factory JobEvent.deleteJob(String id) = DeleteJob;
}
