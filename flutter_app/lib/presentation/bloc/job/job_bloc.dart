import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/domain/usecases/job/create_job_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/delete_job_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/get_job_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/get_jobs_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/update_job_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_state.dart';

@injectable
class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobsUseCase getJobsUseCase;
  final GetJobUseCase getJobUseCase;
  final CreateJobUseCase createJobUseCase;
  final UpdateJobUseCase updateJobUseCase;
  final DeleteJobUseCase deleteJobUseCase;

  JobBloc({
    required this.getJobsUseCase,
    required this.getJobUseCase,
    required this.createJobUseCase,
    required this.updateJobUseCase,
    required this.deleteJobUseCase,
  }) : super(const JobInitial()) {
    on<LoadJobs>(_onLoadJobs);
    on<LoadJobDetail>(_onLoadJobDetail);
    on<CreateJob>(_onCreateJob);
    on<UpdateJob>(_onUpdateJob);
    on<DeleteJob>(_onDeleteJob);
  }

  Future<void> _onLoadJobs(
    LoadJobs event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await getJobsUseCase();
    result.fold(
      (failure) => emit(JobError(failure.message)),
      (jobs) => emit(JobsLoaded(jobs)),
    );
  }

  Future<void> _onLoadJobDetail(
    LoadJobDetail event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await getJobUseCase(event.id);
    result.fold(
      (failure) => emit(JobError(failure.message)),
      (job) => emit(JobDetailLoaded(job)),
    );
  }

  Future<void> _onCreateJob(
    CreateJob event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await createJobUseCase(event.params);
    result.fold(
      (failure) => emit(JobError(failure.message)),
      (_) => emit(const JobOperationSuccess('Job created successfully')),
    );
  }

  Future<void> _onUpdateJob(
    UpdateJob event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await updateJobUseCase(event.id, event.params);
    result.fold(
      (failure) => emit(JobError(failure.message)),
      (_) => emit(const JobOperationSuccess('Job updated successfully')),
    );
  }

  Future<void> _onDeleteJob(
    DeleteJob event,
    Emitter<JobState> emit,
  ) async {
    emit(const JobLoading());
    final result = await deleteJobUseCase(event.id);
    result.fold(
      (failure) => emit(JobError(failure.message)),
      (_) => emit(const JobOperationSuccess('Job deleted successfully')),
    );
  }
}
