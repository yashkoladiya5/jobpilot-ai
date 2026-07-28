import 'package:dartz/dartz.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/dashboard_stats.dart';

/// Abstract definition of the Dashboard Repository.
/// Fetches aggregated statistics for the user's home screen.
abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getStats();
}
