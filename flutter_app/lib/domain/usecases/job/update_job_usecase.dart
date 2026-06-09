import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/domain/repositories/job_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateJobUseCase {
  final JobRepository repository;
  UpdateJobUseCase(this.repository);

  Future<Either<Failure, JobApplication>> call(
      String id, UpdateJobParams params) {
    return repository.updateJob(id, params);
  }
}
