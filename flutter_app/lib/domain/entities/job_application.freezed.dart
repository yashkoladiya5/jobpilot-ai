// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobApplication _$JobApplicationFromJson(Map<String, dynamic> json) {
  return _JobApplication.fromJson(json);
}

/// @nodoc
mixin _$JobApplication {
  String get id => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String? get jobUrl => throw _privateConstructorUsedError;
  String? get salaryRange => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  ApplicationStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get resumeId => throw _privateConstructorUsedError;
  DateTime get appliedDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this JobApplication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobApplicationCopyWith<JobApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobApplicationCopyWith<$Res> {
  factory $JobApplicationCopyWith(
    JobApplication value,
    $Res Function(JobApplication) then,
  ) = _$JobApplicationCopyWithImpl<$Res, JobApplication>;
  @useResult
  $Res call({
    String id,
    String companyName,
    String role,
    String? jobUrl,
    String? salaryRange,
    String? location,
    ApplicationStatus status,
    String? notes,
    String? resumeId,
    DateTime appliedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$JobApplicationCopyWithImpl<$Res, $Val extends JobApplication>
    implements $JobApplicationCopyWith<$Res> {
  _$JobApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? role = null,
    Object? jobUrl = freezed,
    Object? salaryRange = freezed,
    Object? location = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? resumeId = freezed,
    Object? appliedDate = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            jobUrl: freezed == jobUrl
                ? _value.jobUrl
                : jobUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            salaryRange: freezed == salaryRange
                ? _value.salaryRange
                : salaryRange // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ApplicationStatus,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            resumeId: freezed == resumeId
                ? _value.resumeId
                : resumeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            appliedDate: null == appliedDate
                ? _value.appliedDate
                : appliedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobApplicationImplCopyWith<$Res>
    implements $JobApplicationCopyWith<$Res> {
  factory _$$JobApplicationImplCopyWith(
    _$JobApplicationImpl value,
    $Res Function(_$JobApplicationImpl) then,
  ) = __$$JobApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String companyName,
    String role,
    String? jobUrl,
    String? salaryRange,
    String? location,
    ApplicationStatus status,
    String? notes,
    String? resumeId,
    DateTime appliedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$JobApplicationImplCopyWithImpl<$Res>
    extends _$JobApplicationCopyWithImpl<$Res, _$JobApplicationImpl>
    implements _$$JobApplicationImplCopyWith<$Res> {
  __$$JobApplicationImplCopyWithImpl(
    _$JobApplicationImpl _value,
    $Res Function(_$JobApplicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? role = null,
    Object? jobUrl = freezed,
    Object? salaryRange = freezed,
    Object? location = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? resumeId = freezed,
    Object? appliedDate = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$JobApplicationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        jobUrl: freezed == jobUrl
            ? _value.jobUrl
            : jobUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        salaryRange: freezed == salaryRange
            ? _value.salaryRange
            : salaryRange // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ApplicationStatus,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        resumeId: freezed == resumeId
            ? _value.resumeId
            : resumeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        appliedDate: null == appliedDate
            ? _value.appliedDate
            : appliedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobApplicationImpl implements _JobApplication {
  const _$JobApplicationImpl({
    required this.id,
    required this.companyName,
    required this.role,
    this.jobUrl,
    this.salaryRange,
    this.location,
    required this.status,
    this.notes,
    this.resumeId,
    required this.appliedDate,
    this.createdAt,
    this.updatedAt,
  });

  factory _$JobApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobApplicationImplFromJson(json);

  @override
  final String id;
  @override
  final String companyName;
  @override
  final String role;
  @override
  final String? jobUrl;
  @override
  final String? salaryRange;
  @override
  final String? location;
  @override
  final ApplicationStatus status;
  @override
  final String? notes;
  @override
  final String? resumeId;
  @override
  final DateTime appliedDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'JobApplication(id: $id, companyName: $companyName, role: $role, jobUrl: $jobUrl, salaryRange: $salaryRange, location: $location, status: $status, notes: $notes, resumeId: $resumeId, appliedDate: $appliedDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.jobUrl, jobUrl) || other.jobUrl == jobUrl) &&
            (identical(other.salaryRange, salaryRange) ||
                other.salaryRange == salaryRange) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.resumeId, resumeId) ||
                other.resumeId == resumeId) &&
            (identical(other.appliedDate, appliedDate) ||
                other.appliedDate == appliedDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    companyName,
    role,
    jobUrl,
    salaryRange,
    location,
    status,
    notes,
    resumeId,
    appliedDate,
    createdAt,
    updatedAt,
  );

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobApplicationImplCopyWith<_$JobApplicationImpl> get copyWith =>
      __$$JobApplicationImplCopyWithImpl<_$JobApplicationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JobApplicationImplToJson(this);
  }
}

abstract class _JobApplication implements JobApplication {
  const factory _JobApplication({
    required final String id,
    required final String companyName,
    required final String role,
    final String? jobUrl,
    final String? salaryRange,
    final String? location,
    required final ApplicationStatus status,
    final String? notes,
    final String? resumeId,
    required final DateTime appliedDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$JobApplicationImpl;

  factory _JobApplication.fromJson(Map<String, dynamic> json) =
      _$JobApplicationImpl.fromJson;

  @override
  String get id;
  @override
  String get companyName;
  @override
  String get role;
  @override
  String? get jobUrl;
  @override
  String? get salaryRange;
  @override
  String? get location;
  @override
  ApplicationStatus get status;
  @override
  String? get notes;
  @override
  String? get resumeId;
  @override
  DateTime get appliedDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of JobApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobApplicationImplCopyWith<_$JobApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
