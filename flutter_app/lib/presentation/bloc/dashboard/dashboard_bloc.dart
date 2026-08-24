import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/domain/usecases/dashboard/get_stats_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_state.dart';

/// The [DashboardBloc] manages the state of the user's main dashboard view.
/// It fetches and provides the statistical data required for the UI.
@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetStatsUseCase getStatsUseCase;

  DashboardBloc({required this.getStatsUseCase})
      : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<ExportDashboardData>(_onExportDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await getStatsUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (stats) => emit(DashboardLoaded(stats)),
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await getStatsUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (stats) => emit(DashboardLoaded(stats)),
    );
  }

  Future<void> _onExportDashboard(
    ExportDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(const DashboardLoading());
      try {
        // Simulate an export processing delay
        await Future.delayed(const Duration(seconds: 2));
        emit(DashboardExportSuccess(
          currentState.stats, 
          "Data exported successfully to ${event.format} format"
        ));
        // Revert back to the loaded state to restore normal UI
        emit(currentState);
      } catch (e) {
        emit(DashboardError('Failed to export data: ${e.toString()}'));
      }
    }
  }
}
