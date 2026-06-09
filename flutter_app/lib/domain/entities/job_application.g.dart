// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobApplicationImpl _$$JobApplicationImplFromJson(Map<String, dynamic> json) =>
    _$JobApplicationImpl(
      id: json['id'] as String,
      companyName: json['company_name'] as String,
      role: json['role'] as String,
      jobUrl: json['job_url'] as String?,
      salaryRange: json['salary_range'] as String?,
      location: json['location'] as String?,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      resumeId: json['resume_id'] as String?,
      appliedDate: DateTime.parse(json['applied_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$JobApplicationImplToJson(
  _$JobApplicationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'company_name': instance.companyName,
  'role': instance.role,
  'job_url': instance.jobUrl,
  'salary_range': instance.salaryRange,
  'location': instance.location,
  'status': instance.status,
  'notes': instance.notes,
  'resume_id': instance.resumeId,
  'applied_date': instance.appliedDate.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.saved: 'saved',
  ApplicationStatus.applied: 'applied',
  ApplicationStatus.interview: 'interview',
  ApplicationStatus.offer: 'offer',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.withdrawn: 'withdrawn',
};
