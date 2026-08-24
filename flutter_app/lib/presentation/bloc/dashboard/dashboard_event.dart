import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_event.freezed.dart';

/// Defines all the events that can be dispatched to the [DashboardBloc]
/// for loading or refreshing the dashboard data.
@freezed
sealed class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.loadDashboard() = LoadDashboard;
  const factory DashboardEvent.refreshDashboard() = RefreshDashboard;
  const factory DashboardEvent.exportDashboardData({
    @Default('PDF') String format,
    DateTime? startDate,
    DateTime? endDate,
  }) = ExportDashboardData;
}
