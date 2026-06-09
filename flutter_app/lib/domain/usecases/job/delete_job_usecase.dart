import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/repositories/job_repository.dart';

@injectable
class DeleteJobUseCase {
  final JobRepository repository;
  DeleteJobUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteJob(id);
  }
}
