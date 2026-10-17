// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(User user, bool isSessionExpiringSoon)
    authenticated,
    required TResult Function(User user, String pendingAction)
    partiallyAuthenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String message) authError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult? Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String message)? authError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String message)? authError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(PartiallyAuthenticated value)
    partiallyAuthenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(AuthError value) authError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? authError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? authError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthInitialImplCopyWith<$Res> {
  factory _$$AuthInitialImplCopyWith(
    _$AuthInitialImpl value,
    $Res Function(_$AuthInitialImpl) then,
  ) = __$$AuthInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthInitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthInitialImpl>
    implements _$$AuthInitialImplCopyWith<$Res> {
  __$$AuthInitialImplCopyWithImpl(
    _$AuthInitialImpl _value,
    $Res Function(_$AuthInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthInitialImpl implements AuthInitial {
  const _$AuthInitialImpl();

  @override
  String toString() {
    return 'AuthState.authInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(User user, bool isSessionExpiringSoon)
    authenticated,
    required TResult Function(User user, String pendingAction)
    partiallyAuthenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String message) authError,
  }) {
    return authInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult? Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String message)? authError,
  }) {
    return authInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String message)? authError,
    required TResult orElse(),
  }) {
    if (authInitial != null) {
      return authInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(PartiallyAuthenticated value)
    partiallyAuthenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(AuthError value) authError,
  }) {
    return authInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? authError,
  }) {
    return authInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? authError,
    required TResult orElse(),
  }) {
    if (authInitial != null) {
      return authInitial(this);
    }
    return orElse();
  }
}

abstract class AuthInitial implements AuthState {
  const factory AuthInitial() = _$AuthInitialImpl;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
    _$AuthLoadingImpl value,
    $Res Function(_$AuthLoadingImpl) then,
  ) = __$$AuthLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthLoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLoadingImpl>
    implements _$$AuthLoadingImplCopyWith<$Res> {
  __$$AuthLoadingImplCopyWithImpl(
    _$AuthLoadingImpl _value,
    $Res Function(_$AuthLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthLoadingImpl implements AuthLoading {
  const _$AuthLoadingImpl();

  @override
  String toString() {
    return 'AuthState.authLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(User user, bool isSessionExpiringSoon)
    authenticated,
    required TResult Function(User user, String pendingAction)
    partiallyAuthenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String message) authError,
  }) {
    return authLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult? Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String message)? authError,
  }) {
    return authLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String message)? authError,
    required TResult orElse(),
  }) {
    if (authLoading != null) {
      return authLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(PartiallyAuthenticated value)
    partiallyAuthenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(AuthError value) authError,
  }) {
    return authLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? authError,
  }) {
    return authLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? authError,
    required TResult orElse(),
  }) {
    if (authLoading != null) {
      return authLoading(this);
    }
    return orElse();
  }
}

abstract class AuthLoading implements AuthState {
  const factory AuthLoading() = _$AuthLoadingImpl;
}

/// @nodoc
abstract class _$$AuthenticatedImplCopyWith<$Res> {
  factory _$$AuthenticatedImplCopyWith(
    _$AuthenticatedImpl value,
    $Res Function(_$AuthenticatedImpl) then,
  ) = __$$AuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user, bool isSessionExpiringSoon});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedImpl>
    implements _$$AuthenticatedImplCopyWith<$Res> {
  __$$AuthenticatedImplCopyWithImpl(
    _$AuthenticatedImpl _value,
    $Res Function(_$AuthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? isSessionExpiringSoon = null}) {
    return _then(
      _$AuthenticatedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        isSessionExpiringSoon: null == isSessionExpiringSoon
            ? _value.isSessionExpiringSoon
            : isSessionExpiringSoon // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AuthenticatedImpl implements Authenticated {
  const _$AuthenticatedImpl({
    required this.user,
    this.isSessionExpiringSoon = false,
  });

  @override
  final User user;
  @override
  @JsonKey()
  final bool isSessionExpiringSoon;

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user, isSessionExpiringSoon: $isSessionExpiringSoon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isSessionExpiringSoon, isSessionExpiringSoon) ||
                other.isSessionExpiringSoon == isSessionExpiringSoon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, isSessionExpiringSoon);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      __$$AuthenticatedImplCopyWithImpl<_$AuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(User user, bool isSessionExpiringSoon)
    authenticated,
    required TResult Function(User user, String pendingAction)
    partiallyAuthenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String message) authError,
  }) {
    return authenticated(user, isSessionExpiringSoon);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult? Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String message)? authError,
  }) {
    return authenticated?.call(user, isSessionExpiringSoon);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String message)? authError,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user, isSessionExpiringSoon);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(PartiallyAuthenticated value)
    partiallyAuthenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(AuthError value) authError,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? authError,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? authError,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class Authenticated implements AuthState {
  const factory Authenticated({
    required final User user,
    final bool isSessionExpiringSoon,
  }) = _$AuthenticatedImpl;

  User get user;
  bool get isSessionExpiringSoon;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PartiallyAuthenticatedImplCopyWith<$Res> {
  factory _$$PartiallyAuthenticatedImplCopyWith(
    _$PartiallyAuthenticatedImpl value,
    $Res Function(_$PartiallyAuthenticatedImpl) then,
  ) = __$$PartiallyAuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user, String pendingAction});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$PartiallyAuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$PartiallyAuthenticatedImpl>
    implements _$$PartiallyAuthenticatedImplCopyWith<$Res> {
  __$$PartiallyAuthenticatedImplCopyWithImpl(
    _$PartiallyAuthenticatedImpl _value,
    $Res Function(_$PartiallyAuthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? pendingAction = null}) {
    return _then(
      _$PartiallyAuthenticatedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        pendingAction: null == pendingAction
            ? _value.pendingAction
            : pendingAction // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$PartiallyAuthenticatedImpl implements PartiallyAuthenticated {
  const _$PartiallyAuthenticatedImpl({
    required this.user,
    required this.pendingAction,
  });

  @override
  final User user;
  @override
  final String pendingAction;

  @override
  String toString() {
    return 'AuthState.partiallyAuthenticated(user: $user, pendingAction: $pendingAction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartiallyAuthenticatedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.pendingAction, pendingAction) ||
                other.pendingAction == pendingAction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, pendingAction);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartiallyAuthenticatedImplCopyWith<_$PartiallyAuthenticatedImpl>
  get copyWith =>
      __$$PartiallyAuthenticatedImplCopyWithImpl<_$PartiallyAuthenticatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(User user, bool isSessionExpiringSoon)
    authenticated,
    required TResult Function(User user, String pendingAction)
    partiallyAuthenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String message) authError,
  }) {
    return partiallyAuthenticated(user, pendingAction);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult? Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String message)? authError,
  }) {
    return partiallyAuthenticated?.call(user, pendingAction);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String message)? authError,
    required TResult orElse(),
  }) {
    if (partiallyAuthenticated != null) {
      return partiallyAuthenticated(user, pendingAction);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(PartiallyAuthenticated value)
    partiallyAuthenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(AuthError value) authError,
  }) {
    return partiallyAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? authError,
  }) {
    return partiallyAuthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? authError,
    required TResult orElse(),
  }) {
    if (partiallyAuthenticated != null) {
      return partiallyAuthenticated(this);
    }
    return orElse();
  }
}

abstract class PartiallyAuthenticated implements AuthState {
  const factory PartiallyAuthenticated({
    required final User user,
    required final String pendingAction,
  }) = _$PartiallyAuthenticatedImpl;

  User get user;
  String get pendingAction;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartiallyAuthenticatedImplCopyWith<_$PartiallyAuthenticatedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthenticatedImplCopyWith<$Res> {
  factory _$$UnauthenticatedImplCopyWith(
    _$UnauthenticatedImpl value,
    $Res Function(_$UnauthenticatedImpl) then,
  ) = __$$UnauthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$UnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$UnauthenticatedImpl>
    implements _$$UnauthenticatedImplCopyWith<$Res> {
  __$$UnauthenticatedImplCopyWithImpl(
    _$UnauthenticatedImpl _value,
    $Res Function(_$UnauthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed}) {
    return _then(
      _$UnauthenticatedImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UnauthenticatedImpl implements Unauthenticated {
  const _$UnauthenticatedImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'AuthState.unauthenticated(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthenticatedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnauthenticatedImplCopyWith<_$UnauthenticatedImpl> get copyWith =>
      __$$UnauthenticatedImplCopyWithImpl<_$UnauthenticatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(User user, bool isSessionExpiringSoon)
    authenticated,
    required TResult Function(User user, String pendingAction)
    partiallyAuthenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String message) authError,
  }) {
    return unauthenticated(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult? Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String message)? authError,
  }) {
    return unauthenticated?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String message)? authError,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(PartiallyAuthenticated value)
    partiallyAuthenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(AuthError value) authError,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? authError,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? authError,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class Unauthenticated implements AuthState {
  const factory Unauthenticated({final String? message}) =
      _$UnauthenticatedImpl;

  String? get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnauthenticatedImplCopyWith<_$UnauthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
    _$AuthErrorImpl value,
    $Res Function(_$AuthErrorImpl) then,
  ) = __$$AuthErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
    _$AuthErrorImpl _value,
    $Res Function(_$AuthErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$AuthErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthErrorImpl implements AuthError {
  const _$AuthErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.authError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() authInitial,
    required TResult Function() authLoading,
    required TResult Function(User user, bool isSessionExpiringSoon)
    authenticated,
    required TResult Function(User user, String pendingAction)
    partiallyAuthenticated,
    required TResult Function(String? message) unauthenticated,
    required TResult Function(String message) authError,
  }) {
    return authError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? authInitial,
    TResult? Function()? authLoading,
    TResult? Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult? Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult? Function(String? message)? unauthenticated,
    TResult? Function(String message)? authError,
  }) {
    return authError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? authInitial,
    TResult Function()? authLoading,
    TResult Function(User user, bool isSessionExpiringSoon)? authenticated,
    TResult Function(User user, String pendingAction)? partiallyAuthenticated,
    TResult Function(String? message)? unauthenticated,
    TResult Function(String message)? authError,
    required TResult orElse(),
  }) {
    if (authError != null) {
      return authError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) authInitial,
    required TResult Function(AuthLoading value) authLoading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(PartiallyAuthenticated value)
    partiallyAuthenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(AuthError value) authError,
  }) {
    return authError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? authInitial,
    TResult? Function(AuthLoading value)? authLoading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? authError,
  }) {
    return authError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? authInitial,
    TResult Function(AuthLoading value)? authLoading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(PartiallyAuthenticated value)? partiallyAuthenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? authError,
    required TResult orElse(),
  }) {
    if (authError != null) {
      return authError(this);
    }
    return orElse();
  }
}

abstract class AuthError implements AuthState {
  const factory AuthError({required final String message}) = _$AuthErrorImpl;

  String get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
