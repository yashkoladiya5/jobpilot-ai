import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/dashboard_stats.dart';
import 'package:jobpilot_ai/domain/repositories/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetStatsUseCase {
  final DashboardRepository repository;
  GetStatsUseCase(this.repository);

  Future<Either<Failure, DashboardStats>> call() {
    return repository.getStats();
  }
}
