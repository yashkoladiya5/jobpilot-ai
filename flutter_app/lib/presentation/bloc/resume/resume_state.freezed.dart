// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ResumeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Resume> resumes) resumesLoaded,
    required TResult Function(Resume resume) uploadSuccess,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Resume> resumes)? resumesLoaded,
    TResult? Function(Resume resume)? uploadSuccess,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Resume> resumes)? resumesLoaded,
    TResult Function(Resume resume)? uploadSuccess,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResumeInitial value) initial,
    required TResult Function(ResumeLoading value) loading,
    required TResult Function(ResumesLoaded value) resumesLoaded,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(ResumeOperationSuccess value) operationSuccess,
    required TResult Function(ResumeError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResumeInitial value)? initial,
    TResult? Function(ResumeLoading value)? loading,
    TResult? Function(ResumesLoaded value)? resumesLoaded,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(ResumeOperationSuccess value)? operationSuccess,
    TResult? Function(ResumeError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResumeInitial value)? initial,
    TResult Function(ResumeLoading value)? loading,
    TResult Function(ResumesLoaded value)? resumesLoaded,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(ResumeOperationSuccess value)? operationSuccess,
    TResult Function(ResumeError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResumeStateCopyWith<$Res> {
  factory $ResumeStateCopyWith(
    ResumeState value,
    $Res Function(ResumeState) then,
  ) = _$ResumeStateCopyWithImpl<$Res, ResumeState>;
}

/// @nodoc
class _$ResumeStateCopyWithImpl<$Res, $Val extends ResumeState>
    implements $ResumeStateCopyWith<$Res> {
  _$ResumeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ResumeInitialImplCopyWith<$Res> {
  factory _$$ResumeInitialImplCopyWith(
    _$ResumeInitialImpl value,
    $Res Function(_$ResumeInitialImpl) then,
  ) = __$$ResumeInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResumeInitialImplCopyWithImpl<$Res>
    extends _$ResumeStateCopyWithImpl<$Res, _$ResumeInitialImpl>
    implements _$$ResumeInitialImplCopyWith<$Res> {
  __$$ResumeInitialImplCopyWithImpl(
    _$ResumeInitialImpl _value,
    $Res Function(_$ResumeInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResumeInitialImpl implements ResumeInitial {
  const _$ResumeInitialImpl();

  @override
  String toString() {
    return 'ResumeState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResumeInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Resume> resumes) resumesLoaded,
    required TResult Function(Resume resume) uploadSuccess,
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
    TResult? Function(List<Resume> resumes)? resumesLoaded,
    TResult? Function(Resume resume)? uploadSuccess,
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
    TResult Function(List<Resume> resumes)? resumesLoaded,
    TResult Function(Resume resume)? uploadSuccess,
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
    required TResult Function(ResumeInitial value) initial,
    required TResult Function(ResumeLoading value) loading,
    required TResult Function(ResumesLoaded value) resumesLoaded,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(ResumeOperationSuccess value) operationSuccess,
    required TResult Function(ResumeError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResumeInitial value)? initial,
    TResult? Function(ResumeLoading value)? loading,
    TResult? Function(ResumesLoaded value)? resumesLoaded,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(ResumeOperationSuccess value)? operationSuccess,
    TResult? Function(ResumeError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResumeInitial value)? initial,
    TResult Function(ResumeLoading value)? loading,
    TResult Function(ResumesLoaded value)? resumesLoaded,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(ResumeOperationSuccess value)? operationSuccess,
    TResult Function(ResumeError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ResumeInitial implements ResumeState {
  const factory ResumeInitial() = _$ResumeInitialImpl;
}

/// @nodoc
abstract class _$$ResumeLoadingImplCopyWith<$Res> {
  factory _$$ResumeLoadingImplCopyWith(
    _$ResumeLoadingImpl value,
    $Res Function(_$ResumeLoadingImpl) then,
  ) = __$$ResumeLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResumeLoadingImplCopyWithImpl<$Res>
    extends _$ResumeStateCopyWithImpl<$Res, _$ResumeLoadingImpl>
    implements _$$ResumeLoadingImplCopyWith<$Res> {
  __$$ResumeLoadingImplCopyWithImpl(
    _$ResumeLoadingImpl _value,
    $Res Function(_$ResumeLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResumeLoadingImpl implements ResumeLoading {
  const _$ResumeLoadingImpl();

  @override
  String toString() {
    return 'ResumeState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResumeLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Resume> resumes) resumesLoaded,
    required TResult Function(Resume resume) uploadSuccess,
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
    TResult? Function(List<Resume> resumes)? resumesLoaded,
    TResult? Function(Resume resume)? uploadSuccess,
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
    TResult Function(List<Resume> resumes)? resumesLoaded,
    TResult Function(Resume resume)? uploadSuccess,
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
    required TResult Function(ResumeInitial value) initial,
    required TResult Function(ResumeLoading value) loading,
    required TResult Function(ResumesLoaded value) resumesLoaded,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(ResumeOperationSuccess value) operationSuccess,
    required TResult Function(ResumeError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResumeInitial value)? initial,
    TResult? Function(ResumeLoading value)? loading,
    TResult? Function(ResumesLoaded value)? resumesLoaded,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(ResumeOperationSuccess value)? operationSuccess,
    TResult? Function(ResumeError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResumeInitial value)? initial,
    TResult Function(ResumeLoading value)? loading,
    TResult Function(ResumesLoaded value)? resumesLoaded,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(ResumeOperationSuccess value)? operationSuccess,
    TResult Function(ResumeError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ResumeLoading implements ResumeState {
  const factory ResumeLoading() = _$ResumeLoadingImpl;
}

/// @nodoc
abstract class _$$ResumesLoadedImplCopyWith<$Res> {
  factory _$$ResumesLoadedImplCopyWith(
    _$ResumesLoadedImpl value,
    $Res Function(_$ResumesLoadedImpl) then,
  ) = __$$ResumesLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Resume> resumes});
}

/// @nodoc
class __$$ResumesLoadedImplCopyWithImpl<$Res>
    extends _$ResumeStateCopyWithImpl<$Res, _$ResumesLoadedImpl>
    implements _$$ResumesLoadedImplCopyWith<$Res> {
  __$$ResumesLoadedImplCopyWithImpl(
    _$ResumesLoadedImpl _value,
    $Res Function(_$ResumesLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? resumes = null}) {
    return _then(
      _$ResumesLoadedImpl(
        null == resumes
            ? _value._resumes
            : resumes // ignore: cast_nullable_to_non_nullable
                  as List<Resume>,
      ),
    );
  }
}

/// @nodoc

class _$ResumesLoadedImpl implements ResumesLoaded {
  const _$ResumesLoadedImpl(final List<Resume> resumes) : _resumes = resumes;

  final List<Resume> _resumes;
  @override
  List<Resume> get resumes {
    if (_resumes is EqualUnmodifiableListView) return _resumes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resumes);
  }

  @override
  String toString() {
    return 'ResumeState.resumesLoaded(resumes: $resumes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumesLoadedImpl &&
            const DeepCollectionEquality().equals(other._resumes, _resumes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_resumes));

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumesLoadedImplCopyWith<_$ResumesLoadedImpl> get copyWith =>
      __$$ResumesLoadedImplCopyWithImpl<_$ResumesLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Resume> resumes) resumesLoaded,
    required TResult Function(Resume resume) uploadSuccess,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return resumesLoaded(resumes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Resume> resumes)? resumesLoaded,
    TResult? Function(Resume resume)? uploadSuccess,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return resumesLoaded?.call(resumes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Resume> resumes)? resumesLoaded,
    TResult Function(Resume resume)? uploadSuccess,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (resumesLoaded != null) {
      return resumesLoaded(resumes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResumeInitial value) initial,
    required TResult Function(ResumeLoading value) loading,
    required TResult Function(ResumesLoaded value) resumesLoaded,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(ResumeOperationSuccess value) operationSuccess,
    required TResult Function(ResumeError value) error,
  }) {
    return resumesLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResumeInitial value)? initial,
    TResult? Function(ResumeLoading value)? loading,
    TResult? Function(ResumesLoaded value)? resumesLoaded,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(ResumeOperationSuccess value)? operationSuccess,
    TResult? Function(ResumeError value)? error,
  }) {
    return resumesLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResumeInitial value)? initial,
    TResult Function(ResumeLoading value)? loading,
    TResult Function(ResumesLoaded value)? resumesLoaded,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(ResumeOperationSuccess value)? operationSuccess,
    TResult Function(ResumeError value)? error,
    required TResult orElse(),
  }) {
    if (resumesLoaded != null) {
      return resumesLoaded(this);
    }
    return orElse();
  }
}

abstract class ResumesLoaded implements ResumeState {
  const factory ResumesLoaded(final List<Resume> resumes) = _$ResumesLoadedImpl;

  List<Resume> get resumes;

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResumesLoadedImplCopyWith<_$ResumesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadSuccessImplCopyWith<$Res> {
  factory _$$UploadSuccessImplCopyWith(
    _$UploadSuccessImpl value,
    $Res Function(_$UploadSuccessImpl) then,
  ) = __$$UploadSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Resume resume});

  $ResumeCopyWith<$Res> get resume;
}

/// @nodoc
class __$$UploadSuccessImplCopyWithImpl<$Res>
    extends _$ResumeStateCopyWithImpl<$Res, _$UploadSuccessImpl>
    implements _$$UploadSuccessImplCopyWith<$Res> {
  __$$UploadSuccessImplCopyWithImpl(
    _$UploadSuccessImpl _value,
    $Res Function(_$UploadSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? resume = null}) {
    return _then(
      _$UploadSuccessImpl(
        null == resume
            ? _value.resume
            : resume // ignore: cast_nullable_to_non_nullable
                  as Resume,
      ),
    );
  }

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResumeCopyWith<$Res> get resume {
    return $ResumeCopyWith<$Res>(_value.resume, (value) {
      return _then(_value.copyWith(resume: value));
    });
  }
}

/// @nodoc

class _$UploadSuccessImpl implements UploadSuccess {
  const _$UploadSuccessImpl(this.resume);

  @override
  final Resume resume;

  @override
  String toString() {
    return 'ResumeState.uploadSuccess(resume: $resume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadSuccessImpl &&
            (identical(other.resume, resume) || other.resume == resume));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resume);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadSuccessImplCopyWith<_$UploadSuccessImpl> get copyWith =>
      __$$UploadSuccessImplCopyWithImpl<_$UploadSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Resume> resumes) resumesLoaded,
    required TResult Function(Resume resume) uploadSuccess,
    required TResult Function(String message) operationSuccess,
    required TResult Function(String message) error,
  }) {
    return uploadSuccess(resume);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Resume> resumes)? resumesLoaded,
    TResult? Function(Resume resume)? uploadSuccess,
    TResult? Function(String message)? operationSuccess,
    TResult? Function(String message)? error,
  }) {
    return uploadSuccess?.call(resume);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Resume> resumes)? resumesLoaded,
    TResult Function(Resume resume)? uploadSuccess,
    TResult Function(String message)? operationSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (uploadSuccess != null) {
      return uploadSuccess(resume);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResumeInitial value) initial,
    required TResult Function(ResumeLoading value) loading,
    required TResult Function(ResumesLoaded value) resumesLoaded,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(ResumeOperationSuccess value) operationSuccess,
    required TResult Function(ResumeError value) error,
  }) {
    return uploadSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResumeInitial value)? initial,
    TResult? Function(ResumeLoading value)? loading,
    TResult? Function(ResumesLoaded value)? resumesLoaded,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(ResumeOperationSuccess value)? operationSuccess,
    TResult? Function(ResumeError value)? error,
  }) {
    return uploadSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResumeInitial value)? initial,
    TResult Function(ResumeLoading value)? loading,
    TResult Function(ResumesLoaded value)? resumesLoaded,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(ResumeOperationSuccess value)? operationSuccess,
    TResult Function(ResumeError value)? error,
    required TResult orElse(),
  }) {
    if (uploadSuccess != null) {
      return uploadSuccess(this);
    }
    return orElse();
  }
}

abstract class UploadSuccess implements ResumeState {
  const factory UploadSuccess(final Resume resume) = _$UploadSuccessImpl;

  Resume get resume;

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadSuccessImplCopyWith<_$UploadSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResumeOperationSuccessImplCopyWith<$Res> {
  factory _$$ResumeOperationSuccessImplCopyWith(
    _$ResumeOperationSuccessImpl value,
    $Res Function(_$ResumeOperationSuccessImpl) then,
  ) = __$$ResumeOperationSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ResumeOperationSuccessImplCopyWithImpl<$Res>
    extends _$ResumeStateCopyWithImpl<$Res, _$ResumeOperationSuccessImpl>
    implements _$$ResumeOperationSuccessImplCopyWith<$Res> {
  __$$ResumeOperationSuccessImplCopyWithImpl(
    _$ResumeOperationSuccessImpl _value,
    $Res Function(_$ResumeOperationSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ResumeOperationSuccessImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ResumeOperationSuccessImpl implements ResumeOperationSuccess {
  const _$ResumeOperationSuccessImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ResumeState.operationSuccess(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumeOperationSuccessImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumeOperationSuccessImplCopyWith<_$ResumeOperationSuccessImpl>
  get copyWith =>
      __$$ResumeOperationSuccessImplCopyWithImpl<_$ResumeOperationSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Resume> resumes) resumesLoaded,
    required TResult Function(Resume resume) uploadSuccess,
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
    TResult? Function(List<Resume> resumes)? resumesLoaded,
    TResult? Function(Resume resume)? uploadSuccess,
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
    TResult Function(List<Resume> resumes)? resumesLoaded,
    TResult Function(Resume resume)? uploadSuccess,
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
    required TResult Function(ResumeInitial value) initial,
    required TResult Function(ResumeLoading value) loading,
    required TResult Function(ResumesLoaded value) resumesLoaded,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(ResumeOperationSuccess value) operationSuccess,
    required TResult Function(ResumeError value) error,
  }) {
    return operationSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResumeInitial value)? initial,
    TResult? Function(ResumeLoading value)? loading,
    TResult? Function(ResumesLoaded value)? resumesLoaded,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(ResumeOperationSuccess value)? operationSuccess,
    TResult? Function(ResumeError value)? error,
  }) {
    return operationSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResumeInitial value)? initial,
    TResult Function(ResumeLoading value)? loading,
    TResult Function(ResumesLoaded value)? resumesLoaded,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(ResumeOperationSuccess value)? operationSuccess,
    TResult Function(ResumeError value)? error,
    required TResult orElse(),
  }) {
    if (operationSuccess != null) {
      return operationSuccess(this);
    }
    return orElse();
  }
}

abstract class ResumeOperationSuccess implements ResumeState {
  const factory ResumeOperationSuccess(final String message) =
      _$ResumeOperationSuccessImpl;

  String get message;

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResumeOperationSuccessImplCopyWith<_$ResumeOperationSuccessImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResumeErrorImplCopyWith<$Res> {
  factory _$$ResumeErrorImplCopyWith(
    _$ResumeErrorImpl value,
    $Res Function(_$ResumeErrorImpl) then,
  ) = __$$ResumeErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ResumeErrorImplCopyWithImpl<$Res>
    extends _$ResumeStateCopyWithImpl<$Res, _$ResumeErrorImpl>
    implements _$$ResumeErrorImplCopyWith<$Res> {
  __$$ResumeErrorImplCopyWithImpl(
    _$ResumeErrorImpl _value,
    $Res Function(_$ResumeErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ResumeErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ResumeErrorImpl implements ResumeError {
  const _$ResumeErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ResumeState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumeErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumeErrorImplCopyWith<_$ResumeErrorImpl> get copyWith =>
      __$$ResumeErrorImplCopyWithImpl<_$ResumeErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Resume> resumes) resumesLoaded,
    required TResult Function(Resume resume) uploadSuccess,
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
    TResult? Function(List<Resume> resumes)? resumesLoaded,
    TResult? Function(Resume resume)? uploadSuccess,
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
    TResult Function(List<Resume> resumes)? resumesLoaded,
    TResult Function(Resume resume)? uploadSuccess,
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
    required TResult Function(ResumeInitial value) initial,
    required TResult Function(ResumeLoading value) loading,
    required TResult Function(ResumesLoaded value) resumesLoaded,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(ResumeOperationSuccess value) operationSuccess,
    required TResult Function(ResumeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResumeInitial value)? initial,
    TResult? Function(ResumeLoading value)? loading,
    TResult? Function(ResumesLoaded value)? resumesLoaded,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(ResumeOperationSuccess value)? operationSuccess,
    TResult? Function(ResumeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResumeInitial value)? initial,
    TResult Function(ResumeLoading value)? loading,
    TResult Function(ResumesLoaded value)? resumesLoaded,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(ResumeOperationSuccess value)? operationSuccess,
    TResult Function(ResumeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ResumeError implements ResumeState {
  const factory ResumeError(final String message) = _$ResumeErrorImpl;

  String get message;

  /// Create a copy of ResumeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResumeErrorImplCopyWith<_$ResumeErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
