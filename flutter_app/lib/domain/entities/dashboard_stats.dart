import 'package:freezed_annotation/freezed_annotation.dart';
part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int totalApplications,
    required List<StatusCount> byStatus,
    required List<RecentApplication> recentApplications,
    required int recentActivity,
    required int resumeCount,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
}

@freezed
class StatusCount with _$StatusCount {
  const factory StatusCount({
    required String status,
    required int count,
  }) = _StatusCount;

  factory StatusCount.fromJson(Map<String, dynamic> json) =>
      _$StatusCountFromJson(json);
}

@freezed
class RecentApplication with _$RecentApplication {
  const factory RecentApplication({
    required String id,
    required String companyName,
    required String role,
    required String status,
    required DateTime appliedDate,
  }) = _RecentApplication;

  factory RecentApplication.fromJson(Map<String, dynamic> json) =>
      _$RecentApplicationFromJson(json);
}
