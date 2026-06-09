import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';

class CreateJobParams {
  final String companyName;
  final String role;
  final String? jobUrl;
  final String? salaryRange;
  final String? location;
  final ApplicationStatus? status;
  final String? notes;
  final String? resumeId;
  final DateTime? appliedDate;

  const CreateJobParams({
    required this.companyName,
    required this.role,
    this.jobUrl,
    this.salaryRange,
    this.location,
    this.status,
    this.notes,
    this.resumeId,
    this.appliedDate,
  });
}

class UpdateJobParams {
  final String? companyName;
  final String? role;
  final String? jobUrl;
  final String? salaryRange;
  final String? location;
  final ApplicationStatus? status;
  final String? notes;
  final String? resumeId;
  final DateTime? appliedDate;

  const UpdateJobParams({
    this.companyName,
    this.role,
    this.jobUrl,
    this.salaryRange,
    this.location,
    this.status,
    this.notes,
    this.resumeId,
    this.appliedDate,
  });
}

abstract class JobRepository {
  Future<Either<Failure, List<JobApplication>>> getJobs();
  Future<Either<Failure, JobApplication>> getJobById(String id);
  Future<Either<Failure, JobApplication>> createJob(CreateJobParams params);
  Future<Either<Failure, JobApplication>> updateJob(
      String id, UpdateJobParams params);
  Future<Either<Failure, void>> deleteJob(String id);
}
