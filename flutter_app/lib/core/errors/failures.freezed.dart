// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  int? get code => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? code) serverFailure,
    required TResult Function(String message, int? code) networkFailure,
    required TResult Function(String message, int? code) authFailure,
    required TResult Function(String message, int? code) validationFailure,
    required TResult Function(String message, int? code) cacheFailure,
    required TResult Function(String message, int? code) notFoundFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? code)? serverFailure,
    TResult? Function(String message, int? code)? networkFailure,
    TResult? Function(String message, int? code)? authFailure,
    TResult? Function(String message, int? code)? validationFailure,
    TResult? Function(String message, int? code)? cacheFailure,
    TResult? Function(String message, int? code)? notFoundFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? code)? serverFailure,
    TResult Function(String message, int? code)? networkFailure,
    TResult Function(String message, int? code)? authFailure,
    TResult Function(String message, int? code)? validationFailure,
    TResult Function(String message, int? code)? cacheFailure,
    TResult Function(String message, int? code)? notFoundFailure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(NetworkFailure value) networkFailure,
    required TResult Function(AuthFailure value) authFailure,
    required TResult Function(ValidationFailure value) validationFailure,
    required TResult Function(CacheFailure value) cacheFailure,
    required TResult Function(NotFoundFailure value) notFoundFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(NetworkFailure value)? networkFailure,
    TResult? Function(AuthFailure value)? authFailure,
    TResult? Function(ValidationFailure value)? validationFailure,
    TResult? Function(CacheFailure value)? cacheFailure,
    TResult? Function(NotFoundFailure value)? notFoundFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(NetworkFailure value)? networkFailure,
    TResult Function(AuthFailure value)? authFailure,
    TResult Function(ValidationFailure value)? validationFailure,
    TResult Function(CacheFailure value)? cacheFailure,
    TResult Function(NotFoundFailure value)? notFoundFailure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message, int? code});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
    _$ServerFailureImpl value,
    $Res Function(_$ServerFailureImpl) then,
  ) = __$$ServerFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? code});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
    _$ServerFailureImpl _value,
    $Res Function(_$ServerFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$ServerFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$ServerFailureImpl implements ServerFailure {
  const _$ServerFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final int? code;

  @override
  String toString() {
    return 'Failure.serverFailure(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? code) serverFailure,
    required TResult Function(String message, int? code) networkFailure,
    required TResult Function(String message, int? code) authFailure,
    required TResult Function(String message, int? code) validationFailure,
    required TResult Function(String message, int? code) cacheFailure,
    required TResult Function(String message, int? code) notFoundFailure,
  }) {
    return serverFailure(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? code)? serverFailure,
    TResult? Function(String message, int? code)? networkFailure,
    TResult? Function(String message, int? code)? authFailure,
    TResult? Function(String message, int? code)? validationFailure,
    TResult? Function(String message, int? code)? cacheFailure,
    TResult? Function(String message, int? code)? notFoundFailure,
  }) {
    return serverFailure?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? code)? serverFailure,
    TResult Function(String message, int? code)? networkFailure,
    TResult Function(String message, int? code)? authFailure,
    TResult Function(String message, int? code)? validationFailure,
    TResult Function(String message, int? code)? cacheFailure,
    TResult Function(String message, int? code)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (serverFailure != null) {
      return serverFailure(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(NetworkFailure value) networkFailure,
    required TResult Function(AuthFailure value) authFailure,
    required TResult Function(ValidationFailure value) validationFailure,
    required TResult Function(CacheFailure value) cacheFailure,
    required TResult Function(NotFoundFailure value) notFoundFailure,
  }) {
    return serverFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(NetworkFailure value)? networkFailure,
    TResult? Function(AuthFailure value)? authFailure,
    TResult? Function(ValidationFailure value)? validationFailure,
    TResult? Function(CacheFailure value)? cacheFailure,
    TResult? Function(NotFoundFailure value)? notFoundFailure,
  }) {
    return serverFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(NetworkFailure value)? networkFailure,
    TResult Function(AuthFailure value)? authFailure,
    TResult Function(ValidationFailure value)? validationFailure,
    TResult Function(CacheFailure value)? cacheFailure,
    TResult Function(NotFoundFailure value)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (serverFailure != null) {
      return serverFailure(this);
    }
    return orElse();
  }
}

abstract class ServerFailure implements Failure {
  const factory ServerFailure({
    required final String message,
    final int? code,
  }) = _$ServerFailureImpl;

  @override
  String get message;
  @override
  int? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? code});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$NetworkFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final int? code;

  @override
  String toString() {
    return 'Failure.networkFailure(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? code) serverFailure,
    required TResult Function(String message, int? code) networkFailure,
    required TResult Function(String message, int? code) authFailure,
    required TResult Function(String message, int? code) validationFailure,
    required TResult Function(String message, int? code) cacheFailure,
    required TResult Function(String message, int? code) notFoundFailure,
  }) {
    return networkFailure(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? code)? serverFailure,
    TResult? Function(String message, int? code)? networkFailure,
    TResult? Function(String message, int? code)? authFailure,
    TResult? Function(String message, int? code)? validationFailure,
    TResult? Function(String message, int? code)? cacheFailure,
    TResult? Function(String message, int? code)? notFoundFailure,
  }) {
    return networkFailure?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? code)? serverFailure,
    TResult Function(String message, int? code)? networkFailure,
    TResult Function(String message, int? code)? authFailure,
    TResult Function(String message, int? code)? validationFailure,
    TResult Function(String message, int? code)? cacheFailure,
    TResult Function(String message, int? code)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (networkFailure != null) {
      return networkFailure(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(NetworkFailure value) networkFailure,
    required TResult Function(AuthFailure value) authFailure,
    required TResult Function(ValidationFailure value) validationFailure,
    required TResult Function(CacheFailure value) cacheFailure,
    required TResult Function(NotFoundFailure value) notFoundFailure,
  }) {
    return networkFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(NetworkFailure value)? networkFailure,
    TResult? Function(AuthFailure value)? authFailure,
    TResult? Function(ValidationFailure value)? validationFailure,
    TResult? Function(CacheFailure value)? cacheFailure,
    TResult? Function(NotFoundFailure value)? notFoundFailure,
  }) {
    return networkFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(NetworkFailure value)? networkFailure,
    TResult Function(AuthFailure value)? authFailure,
    TResult Function(ValidationFailure value)? validationFailure,
    TResult Function(CacheFailure value)? cacheFailure,
    TResult Function(NotFoundFailure value)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (networkFailure != null) {
      return networkFailure(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({
    required final String message,
    final int? code,
  }) = _$NetworkFailureImpl;

  @override
  String get message;
  @override
  int? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AuthFailureImplCopyWith(
    _$AuthFailureImpl value,
    $Res Function(_$AuthFailureImpl) then,
  ) = __$$AuthFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? code});
}

/// @nodoc
class __$$AuthFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AuthFailureImpl>
    implements _$$AuthFailureImplCopyWith<$Res> {
  __$$AuthFailureImplCopyWithImpl(
    _$AuthFailureImpl _value,
    $Res Function(_$AuthFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$AuthFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$AuthFailureImpl implements AuthFailure {
  const _$AuthFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final int? code;

  @override
  String toString() {
    return 'Failure.authFailure(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      __$$AuthFailureImplCopyWithImpl<_$AuthFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? code) serverFailure,
    required TResult Function(String message, int? code) networkFailure,
    required TResult Function(String message, int? code) authFailure,
    required TResult Function(String message, int? code) validationFailure,
    required TResult Function(String message, int? code) cacheFailure,
    required TResult Function(String message, int? code) notFoundFailure,
  }) {
    return authFailure(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? code)? serverFailure,
    TResult? Function(String message, int? code)? networkFailure,
    TResult? Function(String message, int? code)? authFailure,
    TResult? Function(String message, int? code)? validationFailure,
    TResult? Function(String message, int? code)? cacheFailure,
    TResult? Function(String message, int? code)? notFoundFailure,
  }) {
    return authFailure?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? code)? serverFailure,
    TResult Function(String message, int? code)? networkFailure,
    TResult Function(String message, int? code)? authFailure,
    TResult Function(String message, int? code)? validationFailure,
    TResult Function(String message, int? code)? cacheFailure,
    TResult Function(String message, int? code)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (authFailure != null) {
      return authFailure(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(NetworkFailure value) networkFailure,
    required TResult Function(AuthFailure value) authFailure,
    required TResult Function(ValidationFailure value) validationFailure,
    required TResult Function(CacheFailure value) cacheFailure,
    required TResult Function(NotFoundFailure value) notFoundFailure,
  }) {
    return authFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(NetworkFailure value)? networkFailure,
    TResult? Function(AuthFailure value)? authFailure,
    TResult? Function(ValidationFailure value)? validationFailure,
    TResult? Function(CacheFailure value)? cacheFailure,
    TResult? Function(NotFoundFailure value)? notFoundFailure,
  }) {
    return authFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(NetworkFailure value)? networkFailure,
    TResult Function(AuthFailure value)? authFailure,
    TResult Function(ValidationFailure value)? validationFailure,
    TResult Function(CacheFailure value)? cacheFailure,
    TResult Function(NotFoundFailure value)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (authFailure != null) {
      return authFailure(this);
    }
    return orElse();
  }
}

abstract class AuthFailure implements Failure {
  const factory AuthFailure({required final String message, final int? code}) =
      _$AuthFailureImpl;

  @override
  String get message;
  @override
  int? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(
    _$ValidationFailureImpl value,
    $Res Function(_$ValidationFailureImpl) then,
  ) = __$$ValidationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? code});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(
    _$ValidationFailureImpl _value,
    $Res Function(_$ValidationFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$ValidationFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$ValidationFailureImpl implements ValidationFailure {
  const _$ValidationFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final int? code;

  @override
  String toString() {
    return 'Failure.validationFailure(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? code) serverFailure,
    required TResult Function(String message, int? code) networkFailure,
    required TResult Function(String message, int? code) authFailure,
    required TResult Function(String message, int? code) validationFailure,
    required TResult Function(String message, int? code) cacheFailure,
    required TResult Function(String message, int? code) notFoundFailure,
  }) {
    return validationFailure(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? code)? serverFailure,
    TResult? Function(String message, int? code)? networkFailure,
    TResult? Function(String message, int? code)? authFailure,
    TResult? Function(String message, int? code)? validationFailure,
    TResult? Function(String message, int? code)? cacheFailure,
    TResult? Function(String message, int? code)? notFoundFailure,
  }) {
    return validationFailure?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? code)? serverFailure,
    TResult Function(String message, int? code)? networkFailure,
    TResult Function(String message, int? code)? authFailure,
    TResult Function(String message, int? code)? validationFailure,
    TResult Function(String message, int? code)? cacheFailure,
    TResult Function(String message, int? code)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (validationFailure != null) {
      return validationFailure(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(NetworkFailure value) networkFailure,
    required TResult Function(AuthFailure value) authFailure,
    required TResult Function(ValidationFailure value) validationFailure,
    required TResult Function(CacheFailure value) cacheFailure,
    required TResult Function(NotFoundFailure value) notFoundFailure,
  }) {
    return validationFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(NetworkFailure value)? networkFailure,
    TResult? Function(AuthFailure value)? authFailure,
    TResult? Function(ValidationFailure value)? validationFailure,
    TResult? Function(CacheFailure value)? cacheFailure,
    TResult? Function(NotFoundFailure value)? notFoundFailure,
  }) {
    return validationFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(NetworkFailure value)? networkFailure,
    TResult Function(AuthFailure value)? authFailure,
    TResult Function(ValidationFailure value)? validationFailure,
    TResult Function(CacheFailure value)? cacheFailure,
    TResult Function(NotFoundFailure value)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (validationFailure != null) {
      return validationFailure(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure implements Failure {
  const factory ValidationFailure({
    required final String message,
    final int? code,
  }) = _$ValidationFailureImpl;

  @override
  String get message;
  @override
  int? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CacheFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$CacheFailureImplCopyWith(
    _$CacheFailureImpl value,
    $Res Function(_$CacheFailureImpl) then,
  ) = __$$CacheFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? code});
}

/// @nodoc
class __$$CacheFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CacheFailureImpl>
    implements _$$CacheFailureImplCopyWith<$Res> {
  __$$CacheFailureImplCopyWithImpl(
    _$CacheFailureImpl _value,
    $Res Function(_$CacheFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$CacheFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$CacheFailureImpl implements CacheFailure {
  const _$CacheFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final int? code;

  @override
  String toString() {
    return 'Failure.cacheFailure(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CacheFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      __$$CacheFailureImplCopyWithImpl<_$CacheFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? code) serverFailure,
    required TResult Function(String message, int? code) networkFailure,
    required TResult Function(String message, int? code) authFailure,
    required TResult Function(String message, int? code) validationFailure,
    required TResult Function(String message, int? code) cacheFailure,
    required TResult Function(String message, int? code) notFoundFailure,
  }) {
    return cacheFailure(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? code)? serverFailure,
    TResult? Function(String message, int? code)? networkFailure,
    TResult? Function(String message, int? code)? authFailure,
    TResult? Function(String message, int? code)? validationFailure,
    TResult? Function(String message, int? code)? cacheFailure,
    TResult? Function(String message, int? code)? notFoundFailure,
  }) {
    return cacheFailure?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? code)? serverFailure,
    TResult Function(String message, int? code)? networkFailure,
    TResult Function(String message, int? code)? authFailure,
    TResult Function(String message, int? code)? validationFailure,
    TResult Function(String message, int? code)? cacheFailure,
    TResult Function(String message, int? code)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (cacheFailure != null) {
      return cacheFailure(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(NetworkFailure value) networkFailure,
    required TResult Function(AuthFailure value) authFailure,
    required TResult Function(ValidationFailure value) validationFailure,
    required TResult Function(CacheFailure value) cacheFailure,
    required TResult Function(NotFoundFailure value) notFoundFailure,
  }) {
    return cacheFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(NetworkFailure value)? networkFailure,
    TResult? Function(AuthFailure value)? authFailure,
    TResult? Function(ValidationFailure value)? validationFailure,
    TResult? Function(CacheFailure value)? cacheFailure,
    TResult? Function(NotFoundFailure value)? notFoundFailure,
  }) {
    return cacheFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(NetworkFailure value)? networkFailure,
    TResult Function(AuthFailure value)? authFailure,
    TResult Function(ValidationFailure value)? validationFailure,
    TResult Function(CacheFailure value)? cacheFailure,
    TResult Function(NotFoundFailure value)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (cacheFailure != null) {
      return cacheFailure(this);
    }
    return orElse();
  }
}

abstract class CacheFailure implements Failure {
  const factory CacheFailure({required final String message, final int? code}) =
      _$CacheFailureImpl;

  @override
  String get message;
  @override
  int? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NotFoundFailureImplCopyWith(
    _$NotFoundFailureImpl value,
    $Res Function(_$NotFoundFailureImpl) then,
  ) = __$$NotFoundFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? code});
}

/// @nodoc
class __$$NotFoundFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NotFoundFailureImpl>
    implements _$$NotFoundFailureImplCopyWith<$Res> {
  __$$NotFoundFailureImplCopyWithImpl(
    _$NotFoundFailureImpl _value,
    $Res Function(_$NotFoundFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$NotFoundFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$NotFoundFailureImpl implements NotFoundFailure {
  const _$NotFoundFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final int? code;

  @override
  String toString() {
    return 'Failure.notFoundFailure(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      __$$NotFoundFailureImplCopyWithImpl<_$NotFoundFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? code) serverFailure,
    required TResult Function(String message, int? code) networkFailure,
    required TResult Function(String message, int? code) authFailure,
    required TResult Function(String message, int? code) validationFailure,
    required TResult Function(String message, int? code) cacheFailure,
    required TResult Function(String message, int? code) notFoundFailure,
  }) {
    return notFoundFailure(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? code)? serverFailure,
    TResult? Function(String message, int? code)? networkFailure,
    TResult? Function(String message, int? code)? authFailure,
    TResult? Function(String message, int? code)? validationFailure,
    TResult? Function(String message, int? code)? cacheFailure,
    TResult? Function(String message, int? code)? notFoundFailure,
  }) {
    return notFoundFailure?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? code)? serverFailure,
    TResult Function(String message, int? code)? networkFailure,
    TResult Function(String message, int? code)? authFailure,
    TResult Function(String message, int? code)? validationFailure,
    TResult Function(String message, int? code)? cacheFailure,
    TResult Function(String message, int? code)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (notFoundFailure != null) {
      return notFoundFailure(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(NetworkFailure value) networkFailure,
    required TResult Function(AuthFailure value) authFailure,
    required TResult Function(ValidationFailure value) validationFailure,
    required TResult Function(CacheFailure value) cacheFailure,
    required TResult Function(NotFoundFailure value) notFoundFailure,
  }) {
    return notFoundFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(NetworkFailure value)? networkFailure,
    TResult? Function(AuthFailure value)? authFailure,
    TResult? Function(ValidationFailure value)? validationFailure,
    TResult? Function(CacheFailure value)? cacheFailure,
    TResult? Function(NotFoundFailure value)? notFoundFailure,
  }) {
    return notFoundFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(NetworkFailure value)? networkFailure,
    TResult Function(AuthFailure value)? authFailure,
    TResult Function(ValidationFailure value)? validationFailure,
    TResult Function(CacheFailure value)? cacheFailure,
    TResult Function(NotFoundFailure value)? notFoundFailure,
    required TResult orElse(),
  }) {
    if (notFoundFailure != null) {
      return notFoundFailure(this);
    }
    return orElse();
  }
}

abstract class NotFoundFailure implements Failure {
  const factory NotFoundFailure({
    required final String message,
    final int? code,
  }) = _$NotFoundFailureImpl;

  @override
  String get message;
  @override
  int? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
