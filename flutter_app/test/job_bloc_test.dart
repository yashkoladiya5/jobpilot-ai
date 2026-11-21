import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/domain/repositories/job_repository.dart';
import 'package:jobpilot_ai/domain/usecases/job/create_job_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/delete_job_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/get_job_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/get_jobs_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/job/update_job_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_state.dart';

class FakeJobRepository implements JobRepository {
  Either<Failure, List<JobApplication>>? getJobsResult;
  Either<Failure, JobApplication>? getJobResult;
  Either<Failure, JobApplication>? createJobResult;
  Either<Failure, JobApplication>? updateJobResult;
  Either<Failure, Unit>? deleteJobResult;
  Either<Failure, Map<String, dynamic>>? analyticsResult;
  Either<Failure, List<JobApplication>>? searchResult;

  @override
  Future<Either<Failure, List<JobApplication>>> getJobs({ApplicationStatus? status}) async =>
      getJobsResult ?? const Right([]);

  @override
  Future<Either<Failure, JobApplication>> getJob(String id) async =>
      getJobResult ??
      Right(JobApplication(
        id: id,
        companyName: 'Acme',
        role: 'Dev',
        status: ApplicationStatus.applied,
        appliedDate: DateTime(2025, 1, 1),
      ));

  @override
  Future<Either<Failure, JobApplication>> getJobById(String id) => getJob(id);

  @override
  Future<Either<Failure, JobApplication>> createJob(CreateJobParams params) async =>
      createJobResult ??
      Right(JobApplication(
        id: 'new-id',
        companyName: params.companyName,
        role: params.role,
        status: params.status ?? ApplicationStatus.applied,
        appliedDate: params.appliedDate ?? DateTime(2025, 1, 1),
      ));

  @override
  Future<Either<Failure, JobApplication>> updateJob(String id, UpdateJobParams params) async =>
      updateJobResult ??
      Right(JobApplication(
        id: id,
        companyName: params.companyName ?? 'Acme',
        role: params.role ?? 'Dev',
        status: params.status ?? ApplicationStatus.applied,
        appliedDate: params.appliedDate ?? DateTime(2025, 1, 1),
      ));

  @override
  Future<Either<Failure, Unit>> deleteJob(String id) async =>
      deleteJobResult ?? const Right(unit);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getJobsAnalytics() async =>
      analyticsResult ?? const Right({'total': 1});

  @override
  Future<Either<Failure, List<JobApplication>>> searchJobs(String query) async =>
      searchResult ?? const Right([]);
}

void main() {
  late FakeJobRepository repository;
  late JobBloc jobBloc;

  final tJob = JobApplication(
    id: 'job-1',
    companyName: 'Google',
    role: 'Flutter Engineer',
    status: ApplicationStatus.interview,
    appliedDate: DateTime(2025, 2, 1),
  );

  setUp(() {
    repository = FakeJobRepository();
    jobBloc = JobBloc(
      getJobsUseCase: GetJobsUseCase(repository),
      getJobUseCase: GetJobUseCase(repository),
      createJobUseCase: CreateJobUseCase(repository),
      updateJobUseCase: UpdateJobUseCase(repository),
      deleteJobUseCase: DeleteJobUseCase(repository),
      jobRepository: repository,
    );
  });

  tearDown(() {
    jobBloc.close();
  });

  test('initial state is JobInitial', () {
    expect(jobBloc.state, equals(const JobInitial()));
  });

  blocTest<JobBloc, JobState>(
    'emits [JobLoading, JobsLoaded] when LoadJobs succeeds',
    build: () {
      repository.getJobsResult = Right([tJob]);
      return jobBloc;
    },
    act: (bloc) => bloc.add(const LoadJobs()),
    expect: () => [
      const JobLoading(),
      JobsLoaded([tJob]),
    ],
  );

  blocTest<JobBloc, JobState>(
    'emits [JobLoading, JobError] when LoadJobs fails',
    build: () {
      repository.getJobsResult = const Left(Failure.serverFailure(message: 'Failed to fetch jobs'));
      return jobBloc;
    },
    act: (bloc) => bloc.add(const LoadJobs()),
    expect: () => [
      const JobLoading(),
      const JobError('Failed to fetch jobs'),
    ],
  );

  blocTest<JobBloc, JobState>(
    'emits [JobLoading, JobDetailLoaded] when LoadJobDetail succeeds',
    build: () {
      repository.getJobResult = Right(tJob);
      return jobBloc;
    },
    act: (bloc) => bloc.add(const LoadJobDetail('job-1')),
    expect: () => [
      const JobLoading(),
      JobDetailLoaded(tJob),
    ],
  );

  blocTest<JobBloc, JobState>(
    'emits [JobLoading, JobOperationSuccess, JobLoading, JobsLoaded] when CreateJob succeeds',
    build: () {
      repository.createJobResult = Right(tJob);
      repository.getJobsResult = Right([tJob]);
      return jobBloc;
    },
    act: (bloc) => bloc.add(CreateJob(CreateJobParams(
      companyName: 'Google',
      role: 'Flutter Engineer',
      status: ApplicationStatus.applied,
      appliedDate: DateTime(2025, 2, 1),
    ))),
    expect: () => [
      const JobLoading(),
      const JobOperationSuccess('Job created successfully'),
      const JobLoading(),
      JobsLoaded([tJob]),
    ],
  );

  blocTest<JobBloc, JobState>(
    'emits [JobError] when CreateJob has empty fields without loading',
    build: () => jobBloc,
    act: (bloc) => bloc.add(CreateJob(CreateJobParams(
      companyName: '',
      role: '',
      status: ApplicationStatus.applied,
      appliedDate: DateTime(2025, 2, 1),
    ))),
    expect: () => [
      const JobError('Company Name and Role cannot be empty'),
    ],
  );
}
