// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JobState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<JobApplication> jobs) jobsLoaded,
    required TResult Function(JobApplication job) jobDetailLoaded,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<JobApplication> jobs)? jobsLoaded,
    TResult? Function(JobApplication job)? jobDetailLoaded,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<JobApplication> jobs)? jobsLoaded,
    TResult Function(JobApplication job)? jobDetailLoaded,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JobInitial value) initial,
    required TResult Function(JobLoading value) loading,
    required TResult Function(JobsLoaded value) jobsLoaded,
    required TResult Function(JobDetailLoaded value) jobDetailLoaded,
    required TResult Function(JobOperationSuccess value) operationSuccess,
    required TResult Function(JobError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JobInitial value)? initial,
    TResult? Function(JobLoading value)? loading,
    TResult? Function(JobsLoaded value)? jobsLoaded,
    TResult? Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult? Function(JobOperationSuccess value)? operationSuccess,
    TResult? Function(JobError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JobInitial value)? initial,
    TResult Function(JobLoading value)? loading,
    TResult Function(JobsLoaded value)? jobsLoaded,
    TResult Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult Function(JobOperationSuccess value)? operationSuccess,
    TResult Function(JobError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobStateCopyWith<$Res> {
  factory $JobStateCopyWith(JobState value, $Res Function(JobState) then) =
      _$JobStateCopyWithImpl<$Res, JobState>;
}

/// @nodoc
class _$JobStateCopyWithImpl<$Res, $Val extends JobState>
    implements $JobStateCopyWith<$Res> {
  _$JobStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$JobInitialImplCopyWith<$Res> {
  factory _$$JobInitialImplCopyWith(
    _$JobInitialImpl value,
    $Res Function(_$JobInitialImpl) then,
  ) = __$$JobInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$JobInitialImplCopyWithImpl<$Res>
    extends _$JobStateCopyWithImpl<$Res, _$JobInitialImpl>
    implements _$$JobInitialImplCopyWith<$Res> {
  __$$JobInitialImplCopyWithImpl(
    _$JobInitialImpl _value,
    $Res Function(_$JobInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$JobInitialImpl implements JobInitial {
  const _$JobInitialImpl();

  @override
  String toString() {
    return 'JobState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$JobInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<JobApplication> jobs) jobsLoaded,
    required TResult Function(JobApplication job) jobDetailLoaded,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<JobApplication> jobs)? jobsLoaded,
    TResult? Function(JobApplication job)? jobDetailLoaded,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<JobApplication> jobs)? jobsLoaded,
    TResult Function(JobApplication job)? jobDetailLoaded,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JobInitial value) initial,
    required TResult Function(JobLoading value) loading,
    required TResult Function(JobsLoaded value) jobsLoaded,
    required TResult Function(JobDetailLoaded value) jobDetailLoaded,
    required TResult Function(JobOperationSuccess value) operationSuccess,
    required TResult Function(JobError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JobInitial value)? initial,
    TResult? Function(JobLoading value)? loading,
    TResult? Function(JobsLoaded value)? jobsLoaded,
    TResult? Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult? Function(JobOperationSuccess value)? operationSuccess,
    TResult? Function(JobError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JobInitial value)? initial,
    TResult Function(JobLoading value)? loading,
    TResult Function(JobsLoaded value)? jobsLoaded,
    TResult Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult Function(JobOperationSuccess value)? operationSuccess,
    TResult Function(JobError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class JobInitial implements JobState {
  const factory JobInitial() = _$JobInitialImpl;
}

/// @nodoc
abstract class _$$JobLoadingImplCopyWith<$Res> {
  factory _$$JobLoadingImplCopyWith(
    _$JobLoadingImpl value,
    $Res Function(_$JobLoadingImpl) then,
  ) = __$$JobLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$JobLoadingImplCopyWithImpl<$Res>
    extends _$JobStateCopyWithImpl<$Res, _$JobLoadingImpl>
    implements _$$JobLoadingImplCopyWith<$Res> {
  __$$JobLoadingImplCopyWithImpl(
    _$JobLoadingImpl _value,
    $Res Function(_$JobLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$JobLoadingImpl implements JobLoading {
  const _$JobLoadingImpl();

  @override
  String toString() {
    return 'JobState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$JobLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<JobApplication> jobs) jobsLoaded,
    required TResult Function(JobApplication job) jobDetailLoaded,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<JobApplication> jobs)? jobsLoaded,
    TResult? Function(JobApplication job)? jobDetailLoaded,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<JobApplication> jobs)? jobsLoaded,
    TResult Function(JobApplication job)? jobDetailLoaded,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JobInitial value) initial,
    required TResult Function(JobLoading value) loading,
    required TResult Function(JobsLoaded value) jobsLoaded,
    required TResult Function(JobDetailLoaded value) jobDetailLoaded,
    required TResult Function(JobOperationSuccess value) operationSuccess,
    required TResult Function(JobError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JobInitial value)? initial,
    TResult? Function(JobLoading value)? loading,
    TResult? Function(JobsLoaded value)? jobsLoaded,
    TResult? Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult? Function(JobOperationSuccess value)? operationSuccess,
    TResult? Function(JobError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JobInitial value)? initial,
    TResult Function(JobLoading value)? loading,
    TResult Function(JobsLoaded value)? jobsLoaded,
    TResult Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult Function(JobOperationSuccess value)? operationSuccess,
    TResult Function(JobError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class JobLoading implements JobState {
  const factory JobLoading() = _$JobLoadingImpl;
}

/// @nodoc
abstract class _$$JobsLoadedImplCopyWith<$Res> {
  factory _$$JobsLoadedImplCopyWith(
    _$JobsLoadedImpl value,
    $Res Function(_$JobsLoadedImpl) then,
  ) = __$$JobsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<JobApplication> jobs});
}

/// @nodoc
class __$$JobsLoadedImplCopyWithImpl<$Res>
    extends _$JobStateCopyWithImpl<$Res, _$JobsLoadedImpl>
    implements _$$JobsLoadedImplCopyWith<$Res> {
  __$$JobsLoadedImplCopyWithImpl(
    _$JobsLoadedImpl _value,
    $Res Function(_$JobsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? jobs = null}) {
    return _then(
      _$JobsLoadedImpl(
        null == jobs
            ? _value._jobs
            : jobs // ignore: cast_nullable_to_non_nullable
                  as List<JobApplication>,
      ),
    );
  }
}

/// @nodoc

class _$JobsLoadedImpl implements JobsLoaded {
  const _$JobsLoadedImpl(final List<JobApplication> jobs) : _jobs = jobs;

  final List<JobApplication> _jobs;
  @override
  List<JobApplication> get jobs {
    if (_jobs is EqualUnmodifiableListView) return _jobs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jobs);
  }

  @override
  String toString() {
    return 'JobState.jobsLoaded(jobs: $jobs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobsLoadedImpl &&
            const DeepCollectionEquality().equals(other._jobs, _jobs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_jobs));

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobsLoadedImplCopyWith<_$JobsLoadedImpl> get copyWith =>
      __$$JobsLoadedImplCopyWithImpl<_$JobsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<JobApplication> jobs) jobsLoaded,
    required TResult Function(JobApplication job) jobDetailLoaded,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return jobsLoaded(jobs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<JobApplication> jobs)? jobsLoaded,
    TResult? Function(JobApplication job)? jobDetailLoaded,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return jobsLoaded?.call(jobs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<JobApplication> jobs)? jobsLoaded,
    TResult Function(JobApplication job)? jobDetailLoaded,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (jobsLoaded != null) {
      return jobsLoaded(jobs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JobInitial value) initial,
    required TResult Function(JobLoading value) loading,
    required TResult Function(JobsLoaded value) jobsLoaded,
    required TResult Function(JobDetailLoaded value) jobDetailLoaded,
    required TResult Function(JobOperationSuccess value) operationSuccess,
    required TResult Function(JobError value) error,
  }) {
    return jobsLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JobInitial value)? initial,
    TResult? Function(JobLoading value)? loading,
    TResult? Function(JobsLoaded value)? jobsLoaded,
    TResult? Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult? Function(JobOperationSuccess value)? operationSuccess,
    TResult? Function(JobError value)? error,
  }) {
    return jobsLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JobInitial value)? initial,
    TResult Function(JobLoading value)? loading,
    TResult Function(JobsLoaded value)? jobsLoaded,
    TResult Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult Function(JobOperationSuccess value)? operationSuccess,
    TResult Function(JobError value)? error,
    required TResult orElse(),
  }) {
    if (jobsLoaded != null) {
      return jobsLoaded(this);
    }
    return orElse();
  }
}

abstract class JobsLoaded implements JobState {
  const factory JobsLoaded(final List<JobApplication> jobs) = _$JobsLoadedImpl;

  List<JobApplication> get jobs;

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobsLoadedImplCopyWith<_$JobsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JobDetailLoadedImplCopyWith<$Res> {
  factory _$$JobDetailLoadedImplCopyWith(
    _$JobDetailLoadedImpl value,
    $Res Function(_$JobDetailLoadedImpl) then,
  ) = __$$JobDetailLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({JobApplication job});

  $JobApplicationCopyWith<$Res> get job;
}

/// @nodoc
class __$$JobDetailLoadedImplCopyWithImpl<$Res>
    extends _$JobStateCopyWithImpl<$Res, _$JobDetailLoadedImpl>
    implements _$$JobDetailLoadedImplCopyWith<$Res> {
  __$$JobDetailLoadedImplCopyWithImpl(
    _$JobDetailLoadedImpl _value,
    $Res Function(_$JobDetailLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? job = null}) {
    return _then(
      _$JobDetailLoadedImpl(
        null == job
            ? _value.job
            : job // ignore: cast_nullable_to_non_nullable
                  as JobApplication,
      ),
    );
  }

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JobApplicationCopyWith<$Res> get job {
    return $JobApplicationCopyWith<$Res>(_value.job, (value) {
      return _then(_value.copyWith(job: value));
    });
  }
}

/// @nodoc

class _$JobDetailLoadedImpl implements JobDetailLoaded {
  const _$JobDetailLoadedImpl(this.job);

  @override
  final JobApplication job;

  @override
  String toString() {
    return 'JobState.jobDetailLoaded(job: $job)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobDetailLoadedImpl &&
            (identical(other.job, job) || other.job == job));
  }

  @override
  int get hashCode => Object.hash(runtimeType, job);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobDetailLoadedImplCopyWith<_$JobDetailLoadedImpl> get copyWith =>
      __$$JobDetailLoadedImplCopyWithImpl<_$JobDetailLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<JobApplication> jobs) jobsLoaded,
    required TResult Function(JobApplication job) jobDetailLoaded,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return jobDetailLoaded(job);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<JobApplication> jobs)? jobsLoaded,
    TResult? Function(JobApplication job)? jobDetailLoaded,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return jobDetailLoaded?.call(job);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<JobApplication> jobs)? jobsLoaded,
    TResult Function(JobApplication job)? jobDetailLoaded,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (jobDetailLoaded != null) {
      return jobDetailLoaded(job);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JobInitial value) initial,
    required TResult Function(JobLoading value) loading,
    required TResult Function(JobsLoaded value) jobsLoaded,
    required TResult Function(JobDetailLoaded value) jobDetailLoaded,
    required TResult Function(JobOperationSuccess value) operationSuccess,
    required TResult Function(JobError value) error,
  }) {
    return jobDetailLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JobInitial value)? initial,
    TResult? Function(JobLoading value)? loading,
    TResult? Function(JobsLoaded value)? jobsLoaded,
    TResult? Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult? Function(JobOperationSuccess value)? operationSuccess,
    TResult? Function(JobError value)? error,
  }) {
    return jobDetailLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JobInitial value)? initial,
    TResult Function(JobLoading value)? loading,
    TResult Function(JobsLoaded value)? jobsLoaded,
    TResult Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult Function(JobOperationSuccess value)? operationSuccess,
    TResult Function(JobError value)? error,
    required TResult orElse(),
  }) {
    if (jobDetailLoaded != null) {
      return jobDetailLoaded(this);
    }
    return orElse();
  }
}

abstract class JobDetailLoaded implements JobState {
  const factory JobDetailLoaded(final JobApplication job) =
      _$JobDetailLoadedImpl;

  JobApplication get job;

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobDetailLoadedImplCopyWith<_$JobDetailLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JobOperationSuccessImplCopyWith<$Res> {
  factory _$$JobOperationSuccessImplCopyWith(
    _$JobOperationSuccessImpl value,
    $Res Function(_$JobOperationSuccessImpl) then,
  ) = __$$JobOperationSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$JobOperationSuccessImplCopyWithImpl<$Res>
    extends _$JobStateCopyWithImpl<$Res, _$JobOperationSuccessImpl>
    implements _$$JobOperationSuccessImplCopyWith<$Res> {
  __$$JobOperationSuccessImplCopyWithImpl(
    _$JobOperationSuccessImpl _value,
    $Res Function(_$JobOperationSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$JobOperationSuccessImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JobOperationSuccessImpl implements JobOperationSuccess {
  const _$JobOperationSuccessImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'JobState.operationSuccess(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobOperationSuccessImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobOperationSuccessImplCopyWith<_$JobOperationSuccessImpl> get copyWith =>
      __$$JobOperationSuccessImplCopyWithImpl<_$JobOperationSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<JobApplication> jobs) jobsLoaded,
    required TResult Function(JobApplication job) jobDetailLoaded,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return operationSuccess(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<JobApplication> jobs)? jobsLoaded,
    TResult? Function(JobApplication job)? jobDetailLoaded,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return operationSuccess?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<JobApplication> jobs)? jobsLoaded,
    TResult Function(JobApplication job)? jobDetailLoaded,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (operationSuccess != null) {
      return operationSuccess(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JobInitial value) initial,
    required TResult Function(JobLoading value) loading,
    required TResult Function(JobsLoaded value) jobsLoaded,
    required TResult Function(JobDetailLoaded value) jobDetailLoaded,
    required TResult Function(JobOperationSuccess value) operationSuccess,
    required TResult Function(JobError value) error,
  }) {
    return operationSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JobInitial value)? initial,
    TResult? Function(JobLoading value)? loading,
    TResult? Function(JobsLoaded value)? jobsLoaded,
    TResult? Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult? Function(JobOperationSuccess value)? operationSuccess,
    TResult? Function(JobError value)? error,
  }) {
    return operationSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JobInitial value)? initial,
    TResult Function(JobLoading value)? loading,
    TResult Function(JobsLoaded value)? jobsLoaded,
    TResult Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult Function(JobOperationSuccess value)? operationSuccess,
    TResult Function(JobError value)? error,
    required TResult orElse(),
  }) {
    if (operationSuccess != null) {
      return operationSuccess(this);
    }
    return orElse();
  }
}

abstract class JobOperationSuccess implements JobState {
  const factory JobOperationSuccess(final String message) =
      _$JobOperationSuccessImpl;

  String get message;

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobOperationSuccessImplCopyWith<_$JobOperationSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JobErrorImplCopyWith<$Res> {
  factory _$$JobErrorImplCopyWith(
    _$JobErrorImpl value,
    $Res Function(_$JobErrorImpl) then,
  ) = __$$JobErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$JobErrorImplCopyWithImpl<$Res>
    extends _$JobStateCopyWithImpl<$Res, _$JobErrorImpl>
    implements _$$JobErrorImplCopyWith<$Res> {
  __$$JobErrorImplCopyWithImpl(
    _$JobErrorImpl _value,
    $Res Function(_$JobErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$JobErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$JobErrorImpl implements JobError {
  const _$JobErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'JobState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobErrorImplCopyWith<_$JobErrorImpl> get copyWith =>
      __$$JobErrorImplCopyWithImpl<_$JobErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<JobApplication> jobs) jobsLoaded,
    required TResult Function(JobApplication job) jobDetailLoaded,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<JobApplication> jobs)? jobsLoaded,
    TResult? Function(JobApplication job)? jobDetailLoaded,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<JobApplication> jobs)? jobsLoaded,
    TResult Function(JobApplication job)? jobDetailLoaded,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JobInitial value) initial,
    required TResult Function(JobLoading value) loading,
    required TResult Function(JobsLoaded value) jobsLoaded,
    required TResult Function(JobDetailLoaded value) jobDetailLoaded,
    required TResult Function(JobOperationSuccess value) operationSuccess,
    required TResult Function(JobError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JobInitial value)? initial,
    TResult? Function(JobLoading value)? loading,
    TResult? Function(JobsLoaded value)? jobsLoaded,
    TResult? Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult? Function(JobOperationSuccess value)? operationSuccess,
    TResult? Function(JobError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JobInitial value)? initial,
    TResult Function(JobLoading value)? loading,
    TResult Function(JobsLoaded value)? jobsLoaded,
    TResult Function(JobDetailLoaded value)? jobDetailLoaded,
    TResult Function(JobOperationSuccess value)? operationSuccess,
    TResult Function(JobError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class JobError implements JobState {
  const factory JobError(final String message) = _$JobErrorImpl;

  String get message;

  /// Create a copy of JobState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobErrorImplCopyWith<_$JobErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
