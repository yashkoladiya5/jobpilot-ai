import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/dashboard_stats.dart';
import 'package:jobpilot_ai/domain/repositories/dashboard_repository.dart';
import 'package:jobpilot_ai/domain/usecases/dashboard/get_stats_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_state.dart';

class MockDashboardRepository implements DashboardRepository {
  final bool shouldFail;
  MockDashboardRepository({this.shouldFail = false});

  @override
  Future<Either<Failure, DashboardStats>> getStats() async {
    if (shouldFail) {
      return const Left(Failure.serverFailure(message: 'Failed to fetch dashboard statistics'));
    }
    const stats = DashboardStats(
      totalApplications: 12,
      byStatus: [],
      recentApplications: [],
      recentActivity: 4,
      resumeCount: 1,
    );
    return const Right(stats);
  }
}

void main() {
  group('DashboardBloc Tests', () {
    const testStats = DashboardStats(
      totalApplications: 12,
      byStatus: [],
      recentApplications: [],
      recentActivity: 4,
      resumeCount: 1,
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] on LoadDashboard success',
      build: () {
        final repo = MockDashboardRepository();
        final useCase = GetStatsUseCase(repo);
        return DashboardBloc(getStatsUseCase: useCase);
      },
      act: (bloc) => bloc.add(const LoadDashboard()),
      expect: () => [
        const DashboardLoading(),
        const DashboardLoaded(testStats),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardError] on LoadDashboard failure',
      build: () {
        final repo = MockDashboardRepository(shouldFail: true);
        final useCase = GetStatsUseCase(repo);
        return DashboardBloc(getStatsUseCase: useCase);
      },
      act: (bloc) => bloc.add(const LoadDashboard()),
      expect: () => [
        const DashboardLoading(),
        const DashboardError('Failed to fetch dashboard statistics'),
      ],
    );
  });
}
