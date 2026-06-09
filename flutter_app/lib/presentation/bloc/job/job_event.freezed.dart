// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$JobEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadJobs,
    required TResult Function(String id) loadJobDetail,
    required TResult Function(CreateJobParams params) createJob,
    required TResult Function(String id, UpdateJobParams params) updateJob,
    required TResult Function(String id) deleteJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadJobs,
    TResult? Function(String id)? loadJobDetail,
    TResult? Function(CreateJobParams params)? createJob,
    TResult? Function(String id, UpdateJobParams params)? updateJob,
    TResult? Function(String id)? deleteJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadJobs,
    TResult Function(String id)? loadJobDetail,
    TResult Function(CreateJobParams params)? createJob,
    TResult Function(String id, UpdateJobParams params)? updateJob,
    TResult Function(String id)? deleteJob,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadJobs value) loadJobs,
    required TResult Function(LoadJobDetail value) loadJobDetail,
    required TResult Function(CreateJob value) createJob,
    required TResult Function(UpdateJob value) updateJob,
    required TResult Function(DeleteJob value) deleteJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadJobs value)? loadJobs,
    TResult? Function(LoadJobDetail value)? loadJobDetail,
    TResult? Function(CreateJob value)? createJob,
    TResult? Function(UpdateJob value)? updateJob,
    TResult? Function(DeleteJob value)? deleteJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadJobs value)? loadJobs,
    TResult Function(LoadJobDetail value)? loadJobDetail,
    TResult Function(CreateJob value)? createJob,
    TResult Function(UpdateJob value)? updateJob,
    TResult Function(DeleteJob value)? deleteJob,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobEventCopyWith<$Res> {
  factory $JobEventCopyWith(JobEvent value, $Res Function(JobEvent) then) =
      _$JobEventCopyWithImpl<$Res, JobEvent>;
}

/// @nodoc
class _$JobEventCopyWithImpl<$Res, $Val extends JobEvent>
    implements $JobEventCopyWith<$Res> {
  _$JobEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadJobsImplCopyWith<$Res> {
  factory _$$LoadJobsImplCopyWith(
    _$LoadJobsImpl value,
    $Res Function(_$LoadJobsImpl) then,
  ) = __$$LoadJobsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadJobsImplCopyWithImpl<$Res>
    extends _$JobEventCopyWithImpl<$Res, _$LoadJobsImpl>
    implements _$$LoadJobsImplCopyWith<$Res> {
  __$$LoadJobsImplCopyWithImpl(
    _$LoadJobsImpl _value,
    $Res Function(_$LoadJobsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadJobsImpl implements LoadJobs {
  const _$LoadJobsImpl();

  @override
  String toString() {
    return 'JobEvent.loadJobs()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadJobsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadJobs,
    required TResult Function(String id) loadJobDetail,
    required TResult Function(CreateJobParams params) createJob,
    required TResult Function(String id, UpdateJobParams params) updateJob,
    required TResult Function(String id) deleteJob,
  }) {
    return loadJobs();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadJobs,
    TResult? Function(String id)? loadJobDetail,
    TResult? Function(CreateJobParams params)? createJob,
    TResult? Function(String id, UpdateJobParams params)? updateJob,
    TResult? Function(String id)? deleteJob,
  }) {
    return loadJobs?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadJobs,
    TResult Function(String id)? loadJobDetail,
    TResult Function(CreateJobParams params)? createJob,
    TResult Function(String id, UpdateJobParams params)? updateJob,
    TResult Function(String id)? deleteJob,
    required TResult orElse(),
  }) {
    if (loadJobs != null) {
      return loadJobs();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadJobs value) loadJobs,
    required TResult Function(LoadJobDetail value) loadJobDetail,
    required TResult Function(CreateJob value) createJob,
    required TResult Function(UpdateJob value) updateJob,
    required TResult Function(DeleteJob value) deleteJob,
  }) {
    return loadJobs(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadJobs value)? loadJobs,
    TResult? Function(LoadJobDetail value)? loadJobDetail,
    TResult? Function(CreateJob value)? createJob,
    TResult? Function(UpdateJob value)? updateJob,
    TResult? Function(DeleteJob value)? deleteJob,
  }) {
    return loadJobs?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadJobs value)? loadJobs,
    TResult Function(LoadJobDetail value)? loadJobDetail,
    TResult Function(CreateJob value)? createJob,
    TResult Function(UpdateJob value)? updateJob,
    TResult Function(DeleteJob value)? deleteJob,
    required TResult orElse(),
  }) {
    if (loadJobs != null) {
      return loadJobs(this);
    }
    return orElse();
  }
}

abstract class LoadJobs implements JobEvent {
  const factory LoadJobs() = _$LoadJobsImpl;
}

/// @nodoc
abstract class _$$LoadJobDetailImplCopyWith<$Res> {
  factory _$$LoadJobDetailImplCopyWith(
    _$LoadJobDetailImpl value,
    $Res Function(_$LoadJobDetailImpl) then,
  ) = __$$LoadJobDetailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$LoadJobDetailImplCopyWithImpl<$Res>
    extends _$JobEventCopyWithImpl<$Res, _$LoadJobDetailImpl>
    implements _$$LoadJobDetailImplCopyWith<$Res> {
  __$$LoadJobDetailImplCopyWithImpl(
    _$LoadJobDetailImpl _value,
    $Res Function(_$LoadJobDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$LoadJobDetailImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadJobDetailImpl implements LoadJobDetail {
  const _$LoadJobDetailImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'JobEvent.loadJobDetail(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadJobDetailImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadJobDetailImplCopyWith<_$LoadJobDetailImpl> get copyWith =>
      __$$LoadJobDetailImplCopyWithImpl<_$LoadJobDetailImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadJobs,
    required TResult Function(String id) loadJobDetail,
    required TResult Function(CreateJobParams params) createJob,
    required TResult Function(String id, UpdateJobParams params) updateJob,
    required TResult Function(String id) deleteJob,
  }) {
    return loadJobDetail(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadJobs,
    TResult? Function(String id)? loadJobDetail,
    TResult? Function(CreateJobParams params)? createJob,
    TResult? Function(String id, UpdateJobParams params)? updateJob,
    TResult? Function(String id)? deleteJob,
  }) {
    return loadJobDetail?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadJobs,
    TResult Function(String id)? loadJobDetail,
    TResult Function(CreateJobParams params)? createJob,
    TResult Function(String id, UpdateJobParams params)? updateJob,
    TResult Function(String id)? deleteJob,
    required TResult orElse(),
  }) {
    if (loadJobDetail != null) {
      return loadJobDetail(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadJobs value) loadJobs,
    required TResult Function(LoadJobDetail value) loadJobDetail,
    required TResult Function(CreateJob value) createJob,
    required TResult Function(UpdateJob value) updateJob,
    required TResult Function(DeleteJob value) deleteJob,
  }) {
    return loadJobDetail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadJobs value)? loadJobs,
    TResult? Function(LoadJobDetail value)? loadJobDetail,
    TResult? Function(CreateJob value)? createJob,
    TResult? Function(UpdateJob value)? updateJob,
    TResult? Function(DeleteJob value)? deleteJob,
  }) {
    return loadJobDetail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadJobs value)? loadJobs,
    TResult Function(LoadJobDetail value)? loadJobDetail,
    TResult Function(CreateJob value)? createJob,
    TResult Function(UpdateJob value)? updateJob,
    TResult Function(DeleteJob value)? deleteJob,
    required TResult orElse(),
  }) {
    if (loadJobDetail != null) {
      return loadJobDetail(this);
    }
    return orElse();
  }
}

abstract class LoadJobDetail implements JobEvent {
  const factory LoadJobDetail(final String id) = _$LoadJobDetailImpl;

  String get id;

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadJobDetailImplCopyWith<_$LoadJobDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreateJobImplCopyWith<$Res> {
  factory _$$CreateJobImplCopyWith(
    _$CreateJobImpl value,
    $Res Function(_$CreateJobImpl) then,
  ) = __$$CreateJobImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CreateJobParams params});
}

/// @nodoc
class __$$CreateJobImplCopyWithImpl<$Res>
    extends _$JobEventCopyWithImpl<$Res, _$CreateJobImpl>
    implements _$$CreateJobImplCopyWith<$Res> {
  __$$CreateJobImplCopyWithImpl(
    _$CreateJobImpl _value,
    $Res Function(_$CreateJobImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? params = null}) {
    return _then(
      _$CreateJobImpl(
        null == params
            ? _value.params
            : params // ignore: cast_nullable_to_non_nullable
                  as CreateJobParams,
      ),
    );
  }
}

/// @nodoc

class _$CreateJobImpl implements CreateJob {
  const _$CreateJobImpl(this.params);

  @override
  final CreateJobParams params;

  @override
  String toString() {
    return 'JobEvent.createJob(params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateJobImpl &&
            (identical(other.params, params) || other.params == params));
  }

  @override
  int get hashCode => Object.hash(runtimeType, params);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateJobImplCopyWith<_$CreateJobImpl> get copyWith =>
      __$$CreateJobImplCopyWithImpl<_$CreateJobImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadJobs,
    required TResult Function(String id) loadJobDetail,
    required TResult Function(CreateJobParams params) createJob,
    required TResult Function(String id, UpdateJobParams params) updateJob,
    required TResult Function(String id) deleteJob,
  }) {
    return createJob(params);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadJobs,
    TResult? Function(String id)? loadJobDetail,
    TResult? Function(CreateJobParams params)? createJob,
    TResult? Function(String id, UpdateJobParams params)? updateJob,
    TResult? Function(String id)? deleteJob,
  }) {
    return createJob?.call(params);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadJobs,
    TResult Function(String id)? loadJobDetail,
    TResult Function(CreateJobParams params)? createJob,
    TResult Function(String id, UpdateJobParams params)? updateJob,
    TResult Function(String id)? deleteJob,
    required TResult orElse(),
  }) {
    if (createJob != null) {
      return createJob(params);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadJobs value) loadJobs,
    required TResult Function(LoadJobDetail value) loadJobDetail,
    required TResult Function(CreateJob value) createJob,
    required TResult Function(UpdateJob value) updateJob,
    required TResult Function(DeleteJob value) deleteJob,
  }) {
    return createJob(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadJobs value)? loadJobs,
    TResult? Function(LoadJobDetail value)? loadJobDetail,
    TResult? Function(CreateJob value)? createJob,
    TResult? Function(UpdateJob value)? updateJob,
    TResult? Function(DeleteJob value)? deleteJob,
  }) {
    return createJob?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadJobs value)? loadJobs,
    TResult Function(LoadJobDetail value)? loadJobDetail,
    TResult Function(CreateJob value)? createJob,
    TResult Function(UpdateJob value)? updateJob,
    TResult Function(DeleteJob value)? deleteJob,
    required TResult orElse(),
  }) {
    if (createJob != null) {
      return createJob(this);
    }
    return orElse();
  }
}

abstract class CreateJob implements JobEvent {
  const factory CreateJob(final CreateJobParams params) = _$CreateJobImpl;

  CreateJobParams get params;

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateJobImplCopyWith<_$CreateJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateJobImplCopyWith<$Res> {
  factory _$$UpdateJobImplCopyWith(
    _$UpdateJobImpl value,
    $Res Function(_$UpdateJobImpl) then,
  ) = __$$UpdateJobImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id, UpdateJobParams params});
}

/// @nodoc
class __$$UpdateJobImplCopyWithImpl<$Res>
    extends _$JobEventCopyWithImpl<$Res, _$UpdateJobImpl>
    implements _$$UpdateJobImplCopyWith<$Res> {
  __$$UpdateJobImplCopyWithImpl(
    _$UpdateJobImpl _value,
    $Res Function(_$UpdateJobImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? params = null}) {
    return _then(
      _$UpdateJobImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        null == params
            ? _value.params
            : params // ignore: cast_nullable_to_non_nullable
                  as UpdateJobParams,
      ),
    );
  }
}

/// @nodoc

class _$UpdateJobImpl implements UpdateJob {
  const _$UpdateJobImpl(this.id, this.params);

  @override
  final String id;
  @override
  final UpdateJobParams params;

  @override
  String toString() {
    return 'JobEvent.updateJob(id: $id, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.params, params) || other.params == params));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, params);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateJobImplCopyWith<_$UpdateJobImpl> get copyWith =>
      __$$UpdateJobImplCopyWithImpl<_$UpdateJobImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadJobs,
    required TResult Function(String id) loadJobDetail,
    required TResult Function(CreateJobParams params) createJob,
    required TResult Function(String id, UpdateJobParams params) updateJob,
    required TResult Function(String id) deleteJob,
  }) {
    return updateJob(id, params);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadJobs,
    TResult? Function(String id)? loadJobDetail,
    TResult? Function(CreateJobParams params)? createJob,
    TResult? Function(String id, UpdateJobParams params)? updateJob,
    TResult? Function(String id)? deleteJob,
  }) {
    return updateJob?.call(id, params);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadJobs,
    TResult Function(String id)? loadJobDetail,
    TResult Function(CreateJobParams params)? createJob,
    TResult Function(String id, UpdateJobParams params)? updateJob,
    TResult Function(String id)? deleteJob,
    required TResult orElse(),
  }) {
    if (updateJob != null) {
      return updateJob(id, params);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadJobs value) loadJobs,
    required TResult Function(LoadJobDetail value) loadJobDetail,
    required TResult Function(CreateJob value) createJob,
    required TResult Function(UpdateJob value) updateJob,
    required TResult Function(DeleteJob value) deleteJob,
  }) {
    return updateJob(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadJobs value)? loadJobs,
    TResult? Function(LoadJobDetail value)? loadJobDetail,
    TResult? Function(CreateJob value)? createJob,
    TResult? Function(UpdateJob value)? updateJob,
    TResult? Function(DeleteJob value)? deleteJob,
  }) {
    return updateJob?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadJobs value)? loadJobs,
    TResult Function(LoadJobDetail value)? loadJobDetail,
    TResult Function(CreateJob value)? createJob,
    TResult Function(UpdateJob value)? updateJob,
    TResult Function(DeleteJob value)? deleteJob,
    required TResult orElse(),
  }) {
    if (updateJob != null) {
      return updateJob(this);
    }
    return orElse();
  }
}

abstract class UpdateJob implements JobEvent {
  const factory UpdateJob(final String id, final UpdateJobParams params) =
      _$UpdateJobImpl;

  String get id;
  UpdateJobParams get params;

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateJobImplCopyWith<_$UpdateJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteJobImplCopyWith<$Res> {
  factory _$$DeleteJobImplCopyWith(
    _$DeleteJobImpl value,
    $Res Function(_$DeleteJobImpl) then,
  ) = __$$DeleteJobImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$DeleteJobImplCopyWithImpl<$Res>
    extends _$JobEventCopyWithImpl<$Res, _$DeleteJobImpl>
    implements _$$DeleteJobImplCopyWith<$Res> {
  __$$DeleteJobImplCopyWithImpl(
    _$DeleteJobImpl _value,
    $Res Function(_$DeleteJobImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$DeleteJobImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteJobImpl implements DeleteJob {
  const _$DeleteJobImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'JobEvent.deleteJob(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteJobImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteJobImplCopyWith<_$DeleteJobImpl> get copyWith =>
      __$$DeleteJobImplCopyWithImpl<_$DeleteJobImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadJobs,
    required TResult Function(String id) loadJobDetail,
    required TResult Function(CreateJobParams params) createJob,
    required TResult Function(String id, UpdateJobParams params) updateJob,
    required TResult Function(String id) deleteJob,
  }) {
    return deleteJob(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadJobs,
    TResult? Function(String id)? loadJobDetail,
    TResult? Function(CreateJobParams params)? createJob,
    TResult? Function(String id, UpdateJobParams params)? updateJob,
    TResult? Function(String id)? deleteJob,
  }) {
    return deleteJob?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadJobs,
    TResult Function(String id)? loadJobDetail,
    TResult Function(CreateJobParams params)? createJob,
    TResult Function(String id, UpdateJobParams params)? updateJob,
    TResult Function(String id)? deleteJob,
    required TResult orElse(),
  }) {
    if (deleteJob != null) {
      return deleteJob(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadJobs value) loadJobs,
    required TResult Function(LoadJobDetail value) loadJobDetail,
    required TResult Function(CreateJob value) createJob,
    required TResult Function(UpdateJob value) updateJob,
    required TResult Function(DeleteJob value) deleteJob,
  }) {
    return deleteJob(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadJobs value)? loadJobs,
    TResult? Function(LoadJobDetail value)? loadJobDetail,
    TResult? Function(CreateJob value)? createJob,
    TResult? Function(UpdateJob value)? updateJob,
    TResult? Function(DeleteJob value)? deleteJob,
  }) {
    return deleteJob?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadJobs value)? loadJobs,
    TResult Function(LoadJobDetail value)? loadJobDetail,
    TResult Function(CreateJob value)? createJob,
    TResult Function(UpdateJob value)? updateJob,
    TResult Function(DeleteJob value)? deleteJob,
    required TResult orElse(),
  }) {
    if (deleteJob != null) {
      return deleteJob(this);
    }
    return orElse();
  }
}

abstract class DeleteJob implements JobEvent {
  const factory DeleteJob(final String id) = _$DeleteJobImpl;

  String get id;

  /// Create a copy of JobEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteJobImplCopyWith<_$DeleteJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
