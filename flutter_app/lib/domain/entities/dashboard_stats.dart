import 'package:freezed_annotation/freezed_annotation.dart';
part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @JsonKey(name: 'total_applications') required int totalApplications,
    @JsonKey(name: 'by_status') required List<StatusCount> byStatus,
    @JsonKey(name: 'recent_applications')
    required List<RecentApplication> recentApplications,
    @JsonKey(name: 'recent_activity') required int recentActivity,
    @JsonKey(name: 'resume_count') required int resumeCount,
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
    @JsonKey(name: 'company_name') required String companyName,
    required String role,
    required String status,
    @JsonKey(name: 'applied_date') required DateTime appliedDate,
  }) = _RecentApplication;

  factory RecentApplication.fromJson(Map<String, dynamic> json) =>
      _$RecentApplicationFromJson(json);
}
