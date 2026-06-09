// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobApplicationImpl _$$JobApplicationImplFromJson(Map<String, dynamic> json) =>
    _$JobApplicationImpl(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      role: json['role'] as String,
      jobUrl: json['jobUrl'] as String?,
      salaryRange: json['salaryRange'] as String?,
      location: json['location'] as String?,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      resumeId: json['resumeId'] as String?,
      appliedDate: DateTime.parse(json['appliedDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JobApplicationImplToJson(
  _$JobApplicationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'companyName': instance.companyName,
  'role': instance.role,
  'jobUrl': instance.jobUrl,
  'salaryRange': instance.salaryRange,
  'location': instance.location,
  'status': instance.status,
  'notes': instance.notes,
  'resumeId': instance.resumeId,
  'appliedDate': instance.appliedDate.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.saved: 'SAVED',
  ApplicationStatus.applied: 'APPLIED',
  ApplicationStatus.interview: 'INTERVIEW',
  ApplicationStatus.offer: 'OFFER',
  ApplicationStatus.rejected: 'REJECTED',
  ApplicationStatus.withdrawn: 'WITHDRAWN',
};
