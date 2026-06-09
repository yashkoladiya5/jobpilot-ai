// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      totalApplications: (json['totalApplications'] as num).toInt(),
      byStatus: (json['byStatus'] as List<dynamic>)
          .map((e) => StatusCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentApplications: (json['recentApplications'] as List<dynamic>)
          .map((e) => RecentApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentActivity: (json['recentActivity'] as num).toInt(),
      resumeCount: (json['resumeCount'] as num).toInt(),
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
  _$DashboardStatsImpl instance,
) => <String, dynamic>{
  'totalApplications': instance.totalApplications,
  'byStatus': instance.byStatus,
  'recentApplications': instance.recentApplications,
  'recentActivity': instance.recentActivity,
  'resumeCount': instance.resumeCount,
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
  companyName: json['companyName'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
  appliedDate: DateTime.parse(json['appliedDate'] as String),
);

Map<String, dynamic> _$$RecentApplicationImplToJson(
  _$RecentApplicationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'companyName': instance.companyName,
  'role': instance.role,
  'status': instance.status,
  'appliedDate': instance.appliedDate.toIso8601String(),
};
