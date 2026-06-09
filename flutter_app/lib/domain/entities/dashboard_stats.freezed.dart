// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  @JsonKey(name: 'total_applications')
  int get totalApplications => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_status')
  List<StatusCount> get byStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_applications')
  List<RecentApplication> get recentApplications =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_activity')
  int get recentActivity => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_count')
  int get resumeCount => throw _privateConstructorUsedError;

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
    DashboardStats value,
    $Res Function(DashboardStats) then,
  ) = _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_applications') int totalApplications,
    @JsonKey(name: 'by_status') List<StatusCount> byStatus,
    @JsonKey(name: 'recent_applications')
    List<RecentApplication> recentApplications,
    @JsonKey(name: 'recent_activity') int recentActivity,
    @JsonKey(name: 'resume_count') int resumeCount,
  });
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalApplications = null,
    Object? byStatus = null,
    Object? recentApplications = null,
    Object? recentActivity = null,
    Object? resumeCount = null,
  }) {
    return _then(
      _value.copyWith(
            totalApplications: null == totalApplications
                ? _value.totalApplications
                : totalApplications // ignore: cast_nullable_to_non_nullable
                      as int,
            byStatus: null == byStatus
                ? _value.byStatus
                : byStatus // ignore: cast_nullable_to_non_nullable
                      as List<StatusCount>,
            recentApplications: null == recentApplications
                ? _value.recentApplications
                : recentApplications // ignore: cast_nullable_to_non_nullable
                      as List<RecentApplication>,
            recentActivity: null == recentActivity
                ? _value.recentActivity
                : recentActivity // ignore: cast_nullable_to_non_nullable
                      as int,
            resumeCount: null == resumeCount
                ? _value.resumeCount
                : resumeCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(
    _$DashboardStatsImpl value,
    $Res Function(_$DashboardStatsImpl) then,
  ) = __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_applications') int totalApplications,
    @JsonKey(name: 'by_status') List<StatusCount> byStatus,
    @JsonKey(name: 'recent_applications')
    List<RecentApplication> recentApplications,
    @JsonKey(name: 'recent_activity') int recentActivity,
    @JsonKey(name: 'resume_count') int resumeCount,
  });
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
    _$DashboardStatsImpl _value,
    $Res Function(_$DashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalApplications = null,
    Object? byStatus = null,
    Object? recentApplications = null,
    Object? recentActivity = null,
    Object? resumeCount = null,
  }) {
    return _then(
      _$DashboardStatsImpl(
        totalApplications: null == totalApplications
            ? _value.totalApplications
            : totalApplications // ignore: cast_nullable_to_non_nullable
                  as int,
        byStatus: null == byStatus
            ? _value._byStatus
            : byStatus // ignore: cast_nullable_to_non_nullable
                  as List<StatusCount>,
        recentApplications: null == recentApplications
            ? _value._recentApplications
            : recentApplications // ignore: cast_nullable_to_non_nullable
                  as List<RecentApplication>,
        recentActivity: null == recentActivity
            ? _value.recentActivity
            : recentActivity // ignore: cast_nullable_to_non_nullable
                  as int,
        resumeCount: null == resumeCount
            ? _value.resumeCount
            : resumeCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl({
    @JsonKey(name: 'total_applications') required this.totalApplications,
    @JsonKey(name: 'by_status') required final List<StatusCount> byStatus,
    @JsonKey(name: 'recent_applications')
    required final List<RecentApplication> recentApplications,
    @JsonKey(name: 'recent_activity') required this.recentActivity,
    @JsonKey(name: 'resume_count') required this.resumeCount,
  }) : _byStatus = byStatus,
       _recentApplications = recentApplications;

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_applications')
  final int totalApplications;
  final List<StatusCount> _byStatus;
  @override
  @JsonKey(name: 'by_status')
  List<StatusCount> get byStatus {
    if (_byStatus is EqualUnmodifiableListView) return _byStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byStatus);
  }

  final List<RecentApplication> _recentApplications;
  @override
  @JsonKey(name: 'recent_applications')
  List<RecentApplication> get recentApplications {
    if (_recentApplications is EqualUnmodifiableListView)
      return _recentApplications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentApplications);
  }

  @override
  @JsonKey(name: 'recent_activity')
  final int recentActivity;
  @override
  @JsonKey(name: 'resume_count')
  final int resumeCount;

  @override
  String toString() {
    return 'DashboardStats(totalApplications: $totalApplications, byStatus: $byStatus, recentApplications: $recentApplications, recentActivity: $recentActivity, resumeCount: $resumeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.totalApplications, totalApplications) ||
                other.totalApplications == totalApplications) &&
            const DeepCollectionEquality().equals(other._byStatus, _byStatus) &&
            const DeepCollectionEquality().equals(
              other._recentApplications,
              _recentApplications,
            ) &&
            (identical(other.recentActivity, recentActivity) ||
                other.recentActivity == recentActivity) &&
            (identical(other.resumeCount, resumeCount) ||
                other.resumeCount == resumeCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalApplications,
    const DeepCollectionEquality().hash(_byStatus),
    const DeepCollectionEquality().hash(_recentApplications),
    recentActivity,
    resumeCount,
  );

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(this);
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats({
    @JsonKey(name: 'total_applications') required final int totalApplications,
    @JsonKey(name: 'by_status') required final List<StatusCount> byStatus,
    @JsonKey(name: 'recent_applications')
    required final List<RecentApplication> recentApplications,
    @JsonKey(name: 'recent_activity') required final int recentActivity,
    @JsonKey(name: 'resume_count') required final int resumeCount,
  }) = _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_applications')
  int get totalApplications;
  @override
  @JsonKey(name: 'by_status')
  List<StatusCount> get byStatus;
  @override
  @JsonKey(name: 'recent_applications')
  List<RecentApplication> get recentApplications;
  @override
  @JsonKey(name: 'recent_activity')
  int get recentActivity;
  @override
  @JsonKey(name: 'resume_count')
  int get resumeCount;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StatusCount _$StatusCountFromJson(Map<String, dynamic> json) {
  return _StatusCount.fromJson(json);
}

/// @nodoc
mixin _$StatusCount {
  String get status => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this StatusCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusCountCopyWith<StatusCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusCountCopyWith<$Res> {
  factory $StatusCountCopyWith(
    StatusCount value,
    $Res Function(StatusCount) then,
  ) = _$StatusCountCopyWithImpl<$Res, StatusCount>;
  @useResult
  $Res call({String status, int count});
}

/// @nodoc
class _$StatusCountCopyWithImpl<$Res, $Val extends StatusCount>
    implements $StatusCountCopyWith<$Res> {
  _$StatusCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatusCountImplCopyWith<$Res>
    implements $StatusCountCopyWith<$Res> {
  factory _$$StatusCountImplCopyWith(
    _$StatusCountImpl value,
    $Res Function(_$StatusCountImpl) then,
  ) = __$$StatusCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, int count});
}

/// @nodoc
class __$$StatusCountImplCopyWithImpl<$Res>
    extends _$StatusCountCopyWithImpl<$Res, _$StatusCountImpl>
    implements _$$StatusCountImplCopyWith<$Res> {
  __$$StatusCountImplCopyWithImpl(
    _$StatusCountImpl _value,
    $Res Function(_$StatusCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatusCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? count = null}) {
    return _then(
      _$StatusCountImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusCountImpl implements _StatusCount {
  const _$StatusCountImpl({required this.status, required this.count});

  factory _$StatusCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusCountImplFromJson(json);

  @override
  final String status;
  @override
  final int count;

  @override
  String toString() {
    return 'StatusCount(status: $status, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusCountImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, count);

  /// Create a copy of StatusCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusCountImplCopyWith<_$StatusCountImpl> get copyWith =>
      __$$StatusCountImplCopyWithImpl<_$StatusCountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusCountImplToJson(this);
  }
}

abstract class _StatusCount implements StatusCount {
  const factory _StatusCount({
    required final String status,
    required final int count,
  }) = _$StatusCountImpl;

  factory _StatusCount.fromJson(Map<String, dynamic> json) =
      _$StatusCountImpl.fromJson;

  @override
  String get status;
  @override
  int get count;

  /// Create a copy of StatusCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusCountImplCopyWith<_$StatusCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentApplication _$RecentApplicationFromJson(Map<String, dynamic> json) {
  return _RecentApplication.fromJson(json);
}

/// @nodoc
mixin _$RecentApplication {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'applied_date')
  DateTime get appliedDate => throw _privateConstructorUsedError;

  /// Serializes this RecentApplication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentApplicationCopyWith<RecentApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentApplicationCopyWith<$Res> {
  factory $RecentApplicationCopyWith(
    RecentApplication value,
    $Res Function(RecentApplication) then,
  ) = _$RecentApplicationCopyWithImpl<$Res, RecentApplication>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'company_name') String companyName,
    String role,
    String status,
    @JsonKey(name: 'applied_date') DateTime appliedDate,
  });
}

/// @nodoc
class _$RecentApplicationCopyWithImpl<$Res, $Val extends RecentApplication>
    implements $RecentApplicationCopyWith<$Res> {
  _$RecentApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? role = null,
    Object? status = null,
    Object? appliedDate = null,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            appliedDate: null == appliedDate
                ? _value.appliedDate
                : appliedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentApplicationImplCopyWith<$Res>
    implements $RecentApplicationCopyWith<$Res> {
  factory _$$RecentApplicationImplCopyWith(
    _$RecentApplicationImpl value,
    $Res Function(_$RecentApplicationImpl) then,
  ) = __$$RecentApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'company_name') String companyName,
    String role,
    String status,
    @JsonKey(name: 'applied_date') DateTime appliedDate,
  });
}

/// @nodoc
class __$$RecentApplicationImplCopyWithImpl<$Res>
    extends _$RecentApplicationCopyWithImpl<$Res, _$RecentApplicationImpl>
    implements _$$RecentApplicationImplCopyWith<$Res> {
  __$$RecentApplicationImplCopyWithImpl(
    _$RecentApplicationImpl _value,
    $Res Function(_$RecentApplicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? role = null,
    Object? status = null,
    Object? appliedDate = null,
  }) {
    return _then(
      _$RecentApplicationImpl(
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        appliedDate: null == appliedDate
            ? _value.appliedDate
            : appliedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentApplicationImpl implements _RecentApplication {
  const _$RecentApplicationImpl({
    required this.id,
    @JsonKey(name: 'company_name') required this.companyName,
    required this.role,
    required this.status,
    @JsonKey(name: 'applied_date') required this.appliedDate,
  });

  factory _$RecentApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentApplicationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  final String role;
  @override
  final String status;
  @override
  @JsonKey(name: 'applied_date')
  final DateTime appliedDate;

  @override
  String toString() {
    return 'RecentApplication(id: $id, companyName: $companyName, role: $role, status: $status, appliedDate: $appliedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appliedDate, appliedDate) ||
                other.appliedDate == appliedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, companyName, role, status, appliedDate);

  /// Create a copy of RecentApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentApplicationImplCopyWith<_$RecentApplicationImpl> get copyWith =>
      __$$RecentApplicationImplCopyWithImpl<_$RecentApplicationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentApplicationImplToJson(this);
  }
}

abstract class _RecentApplication implements RecentApplication {
  const factory _RecentApplication({
    required final String id,
    @JsonKey(name: 'company_name') required final String companyName,
    required final String role,
    required final String status,
    @JsonKey(name: 'applied_date') required final DateTime appliedDate,
  }) = _$RecentApplicationImpl;

  factory _RecentApplication.fromJson(Map<String, dynamic> json) =
      _$RecentApplicationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  String get role;
  @override
  String get status;
  @override
  @JsonKey(name: 'applied_date')
  DateTime get appliedDate;

  /// Create a copy of RecentApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentApplicationImplCopyWith<_$RecentApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
