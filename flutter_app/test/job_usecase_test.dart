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

class MockJobRepository implements JobRepository {
  final List<JobApplication> _jobs = [
    JobApplication(
      id: 'job-1',
      companyName: 'Linear',
      role: 'Staff Frontend Engineer',
      status: ApplicationStatus.applied,
      appliedDate: DateTime.parse('2026-11-20T10:00:00.000Z'),
    ),
  ];

  @override
  Future<Either<Failure, List<JobApplication>>> getJobs() async {
    return Right(_jobs);
  }

  @override
  Future<Either<Failure, JobApplication>> getJobById(String id) async {
    final match = _jobs.where((j) => j.id == id).firstOrNull;
    if (match != null) return Right(match);
    return const Left(Failure.notFoundFailure(message: 'Job not found'));
  }

  @override
  Future<Either<Failure, JobApplication>> createJob(CreateJobParams params) async {
    final newJob = JobApplication(
      id: 'job-new',
      companyName: params.companyName,
      role: params.role,
      status: params.status ?? ApplicationStatus.saved,
      appliedDate: params.appliedDate ?? DateTime.now(),
    );
    _jobs.add(newJob);
    return Right(newJob);
  }

  @override
  Future<Either<Failure, JobApplication>> updateJob(String id, UpdateJobParams params) async {
    final index = _jobs.indexWhere((j) => j.id == id);
    if (index != -1) {
      final updated = _jobs[index].copyWith(
        status: params.status ?? _jobs[index].status,
      );
      _jobs[index] = updated;
      return Right(updated);
    }
    return const Left(Failure.notFoundFailure(message: 'Job not found'));
  }

  @override
  Future<Either<Failure, void>> deleteJob(String id) async {
    _jobs.removeWhere((j) => j.id == id);
    return const Right(null);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getJobsAnalytics() async {
    return const Right({'total': 1});
  }

  @override
  Future<Either<Failure, List<JobApplication>>> searchJobs(String query) async {
    return Right(_jobs);
  }
}

void main() {
  late MockJobRepository mockRepo;
  late GetJobsUseCase getJobsUseCase;
  late GetJobUseCase getJobUseCase;
  late CreateJobUseCase createJobUseCase;
  late UpdateJobUseCase updateJobUseCase;
  late DeleteJobUseCase deleteJobUseCase;

  setUp(() {
    mockRepo = MockJobRepository();
    getJobsUseCase = GetJobsUseCase(mockRepo);
    getJobUseCase = GetJobUseCase(mockRepo);
    createJobUseCase = CreateJobUseCase(mockRepo);
    updateJobUseCase = UpdateJobUseCase(mockRepo);
    deleteJobUseCase = DeleteJobUseCase(mockRepo);
  });

  group('Job Application UseCases Tests', () {
    test('GetJobsUseCase returns list of applications', () async {
      final result = await getJobsUseCase();
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (jobs) => expect(jobs.length, equals(1)),
      );
    });

    test('GetJobUseCase retrieves specific application by id', () async {
      final result = await getJobUseCase('job-1');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (job) => expect(job.companyName, equals('Linear')),
      );
    });

    test('CreateJobUseCase adds new job application successfully', () async {
      final params = CreateJobParams(
        companyName: 'Airbnb',
        role: 'Mobile Architect',
        status: ApplicationStatus.saved,
        appliedDate: DateTime.now(),
      );

      final result = await createJobUseCase(params);
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (job) => expect(job.companyName, equals('Airbnb')),
      );
    });

    test('UpdateJobUseCase updates existing job application stage', () async {
      const params = UpdateJobParams(status: ApplicationStatus.interview);
      final result = await updateJobUseCase('job-1', params);
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (job) => expect(job.status, equals(ApplicationStatus.interview)),
      );
    });

    test('DeleteJobUseCase deletes job application by id', () async {
      final result = await deleteJobUseCase('job-1');
      expect(result.isRight(), isTrue);
    });
  });
}
