// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      totalApplications: (json['total_applications'] as num).toInt(),
      byStatus: (json['by_status'] as List<dynamic>)
          .map((e) => StatusCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentApplications: (json['recent_applications'] as List<dynamic>)
          .map((e) => RecentApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentActivity: (json['recent_activity'] as num).toInt(),
      resumeCount: (json['resume_count'] as num).toInt(),
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
  _$DashboardStatsImpl instance,
) => <String, dynamic>{
  'total_applications': instance.totalApplications,
  'by_status': instance.byStatus,
  'recent_applications': instance.recentApplications,
  'recent_activity': instance.recentActivity,
  'resume_count': instance.resumeCount,
};

_$StatusCountImpl _$$StatusCountImplFromJson(Map<String, dynamic> json) =>
    _$StatusCountImpl(
      status: json['status'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$StatusCountImplToJson(_$StatusCountImpl instance) =>
    <String, dynamic>{'status': instance.status, 'count': instance.count};

_$RecentApplicationImpl _$$RecentApplicationImplFromJson(
  Map<String, dynamic> json,
) => _$RecentApplicationImpl(
  id: json['id'] as String,
  companyName: json['company_name'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
  appliedDate: DateTime.parse(json['applied_date'] as String),
);

Map<String, dynamic> _$$RecentApplicationImplToJson(
  _$RecentApplicationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'company_name': instance.companyName,
  'role': instance.role,
  'status': instance.status,
  'applied_date': instance.appliedDate.toIso8601String(),
};
