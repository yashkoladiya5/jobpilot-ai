import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/domain/repositories/job_repository.dart';

@injectable
class CreateJobUseCase {
  final JobRepository repository;
  CreateJobUseCase(this.repository);

  Future<Either<Failure, JobApplication>> call(CreateJobParams params) {
    return repository.createJob(params);
  }
}
