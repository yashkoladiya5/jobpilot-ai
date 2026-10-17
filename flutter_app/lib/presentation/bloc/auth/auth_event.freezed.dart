// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    loginSubmitted,
    required TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )
    registerSubmitted,
    required TResult Function() checkAuthStatus,
    required TResult Function() logoutRequested,
    required TResult Function() sessionExpiringWarningReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult? Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult? Function()? checkAuthStatus,
    TResult? Function()? logoutRequested,
    TResult? Function()? sessionExpiringWarningReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult Function()? checkAuthStatus,
    TResult Function()? logoutRequested,
    TResult Function()? sessionExpiringWarningReceived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(RegisterSubmitted value) registerSubmitted,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(LogoutRequested value) logoutRequested,
    required TResult Function(SessionExpiringWarningReceived value)
    sessionExpiringWarningReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(RegisterSubmitted value)? registerSubmitted,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(LogoutRequested value)? logoutRequested,
    TResult? Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(RegisterSubmitted value)? registerSubmitted,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(LogoutRequested value)? logoutRequested,
    TResult Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoginSubmittedImplCopyWith<$Res> {
  factory _$$LoginSubmittedImplCopyWith(
    _$LoginSubmittedImpl value,
    $Res Function(_$LoginSubmittedImpl) then,
  ) = __$$LoginSubmittedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password, bool rememberMe});
}

/// @nodoc
class __$$LoginSubmittedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$LoginSubmittedImpl>
    implements _$$LoginSubmittedImplCopyWith<$Res> {
  __$$LoginSubmittedImplCopyWithImpl(
    _$LoginSubmittedImpl _value,
    $Res Function(_$LoginSubmittedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(
      _$LoginSubmittedImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        rememberMe: null == rememberMe
            ? _value.rememberMe
            : rememberMe // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LoginSubmittedImpl implements LoginSubmitted {
  const _$LoginSubmittedImpl({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey()
  final bool rememberMe;

  @override
  String toString() {
    return 'AuthEvent.loginSubmitted(email: $email, password: $password, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginSubmittedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, rememberMe);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginSubmittedImplCopyWith<_$LoginSubmittedImpl> get copyWith =>
      __$$LoginSubmittedImplCopyWithImpl<_$LoginSubmittedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    loginSubmitted,
    required TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )
    registerSubmitted,
    required TResult Function() checkAuthStatus,
    required TResult Function() logoutRequested,
    required TResult Function() sessionExpiringWarningReceived,
  }) {
    return loginSubmitted(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult? Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult? Function()? checkAuthStatus,
    TResult? Function()? logoutRequested,
    TResult? Function()? sessionExpiringWarningReceived,
  }) {
    return loginSubmitted?.call(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult Function()? checkAuthStatus,
    TResult Function()? logoutRequested,
    TResult Function()? sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (loginSubmitted != null) {
      return loginSubmitted(email, password, rememberMe);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(RegisterSubmitted value) registerSubmitted,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(LogoutRequested value) logoutRequested,
    required TResult Function(SessionExpiringWarningReceived value)
    sessionExpiringWarningReceived,
  }) {
    return loginSubmitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(RegisterSubmitted value)? registerSubmitted,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(LogoutRequested value)? logoutRequested,
    TResult? Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
  }) {
    return loginSubmitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(RegisterSubmitted value)? registerSubmitted,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(LogoutRequested value)? logoutRequested,
    TResult Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (loginSubmitted != null) {
      return loginSubmitted(this);
    }
    return orElse();
  }
}

abstract class LoginSubmitted implements AuthEvent {
  const factory LoginSubmitted({
    required final String email,
    required final String password,
    final bool rememberMe,
  }) = _$LoginSubmittedImpl;

  String get email;
  String get password;
  bool get rememberMe;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginSubmittedImplCopyWith<_$LoginSubmittedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegisterSubmittedImplCopyWith<$Res> {
  factory _$$RegisterSubmittedImplCopyWith(
    _$RegisterSubmittedImpl value,
    $Res Function(_$RegisterSubmittedImpl) then,
  ) = __$$RegisterSubmittedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String email,
    String password,
    String name,
    bool subscribeToNewsletter,
  });
}

/// @nodoc
class __$$RegisterSubmittedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$RegisterSubmittedImpl>
    implements _$$RegisterSubmittedImplCopyWith<$Res> {
  __$$RegisterSubmittedImplCopyWithImpl(
    _$RegisterSubmittedImpl _value,
    $Res Function(_$RegisterSubmittedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? name = null,
    Object? subscribeToNewsletter = null,
  }) {
    return _then(
      _$RegisterSubmittedImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        subscribeToNewsletter: null == subscribeToNewsletter
            ? _value.subscribeToNewsletter
            : subscribeToNewsletter // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RegisterSubmittedImpl implements RegisterSubmitted {
  const _$RegisterSubmittedImpl({
    required this.email,
    required this.password,
    required this.name,
    this.subscribeToNewsletter = false,
  });

  @override
  final String email;
  @override
  final String password;
  @override
  final String name;
  @override
  @JsonKey()
  final bool subscribeToNewsletter;

  @override
  String toString() {
    return 'AuthEvent.registerSubmitted(email: $email, password: $password, name: $name, subscribeToNewsletter: $subscribeToNewsletter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterSubmittedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subscribeToNewsletter, subscribeToNewsletter) ||
                other.subscribeToNewsletter == subscribeToNewsletter));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, name, subscribeToNewsletter);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterSubmittedImplCopyWith<_$RegisterSubmittedImpl> get copyWith =>
      __$$RegisterSubmittedImplCopyWithImpl<_$RegisterSubmittedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    loginSubmitted,
    required TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )
    registerSubmitted,
    required TResult Function() checkAuthStatus,
    required TResult Function() logoutRequested,
    required TResult Function() sessionExpiringWarningReceived,
  }) {
    return registerSubmitted(email, password, name, subscribeToNewsletter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult? Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult? Function()? checkAuthStatus,
    TResult? Function()? logoutRequested,
    TResult? Function()? sessionExpiringWarningReceived,
  }) {
    return registerSubmitted?.call(
      email,
      password,
      name,
      subscribeToNewsletter,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult Function()? checkAuthStatus,
    TResult Function()? logoutRequested,
    TResult Function()? sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (registerSubmitted != null) {
      return registerSubmitted(email, password, name, subscribeToNewsletter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(RegisterSubmitted value) registerSubmitted,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(LogoutRequested value) logoutRequested,
    required TResult Function(SessionExpiringWarningReceived value)
    sessionExpiringWarningReceived,
  }) {
    return registerSubmitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(RegisterSubmitted value)? registerSubmitted,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(LogoutRequested value)? logoutRequested,
    TResult? Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
  }) {
    return registerSubmitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(RegisterSubmitted value)? registerSubmitted,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(LogoutRequested value)? logoutRequested,
    TResult Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (registerSubmitted != null) {
      return registerSubmitted(this);
    }
    return orElse();
  }
}

abstract class RegisterSubmitted implements AuthEvent {
  const factory RegisterSubmitted({
    required final String email,
    required final String password,
    required final String name,
    final bool subscribeToNewsletter,
  }) = _$RegisterSubmittedImpl;

  String get email;
  String get password;
  String get name;
  bool get subscribeToNewsletter;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterSubmittedImplCopyWith<_$RegisterSubmittedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckAuthStatusImplCopyWith<$Res> {
  factory _$$CheckAuthStatusImplCopyWith(
    _$CheckAuthStatusImpl value,
    $Res Function(_$CheckAuthStatusImpl) then,
  ) = __$$CheckAuthStatusImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckAuthStatusImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$CheckAuthStatusImpl>
    implements _$$CheckAuthStatusImplCopyWith<$Res> {
  __$$CheckAuthStatusImplCopyWithImpl(
    _$CheckAuthStatusImpl _value,
    $Res Function(_$CheckAuthStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckAuthStatusImpl implements CheckAuthStatus {
  const _$CheckAuthStatusImpl();

  @override
  String toString() {
    return 'AuthEvent.checkAuthStatus()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckAuthStatusImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    loginSubmitted,
    required TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )
    registerSubmitted,
    required TResult Function() checkAuthStatus,
    required TResult Function() logoutRequested,
    required TResult Function() sessionExpiringWarningReceived,
  }) {
    return checkAuthStatus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult? Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult? Function()? checkAuthStatus,
    TResult? Function()? logoutRequested,
    TResult? Function()? sessionExpiringWarningReceived,
  }) {
    return checkAuthStatus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult Function()? checkAuthStatus,
    TResult Function()? logoutRequested,
    TResult Function()? sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(RegisterSubmitted value) registerSubmitted,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(LogoutRequested value) logoutRequested,
    required TResult Function(SessionExpiringWarningReceived value)
    sessionExpiringWarningReceived,
  }) {
    return checkAuthStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(RegisterSubmitted value)? registerSubmitted,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(LogoutRequested value)? logoutRequested,
    TResult? Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
  }) {
    return checkAuthStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(RegisterSubmitted value)? registerSubmitted,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(LogoutRequested value)? logoutRequested,
    TResult Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus(this);
    }
    return orElse();
  }
}

abstract class CheckAuthStatus implements AuthEvent {
  const factory CheckAuthStatus() = _$CheckAuthStatusImpl;
}

/// @nodoc
abstract class _$$LogoutRequestedImplCopyWith<$Res> {
  factory _$$LogoutRequestedImplCopyWith(
    _$LogoutRequestedImpl value,
    $Res Function(_$LogoutRequestedImpl) then,
  ) = __$$LogoutRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LogoutRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$LogoutRequestedImpl>
    implements _$$LogoutRequestedImplCopyWith<$Res> {
  __$$LogoutRequestedImplCopyWithImpl(
    _$LogoutRequestedImpl _value,
    $Res Function(_$LogoutRequestedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LogoutRequestedImpl implements LogoutRequested {
  const _$LogoutRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.logoutRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LogoutRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    loginSubmitted,
    required TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )
    registerSubmitted,
    required TResult Function() checkAuthStatus,
    required TResult Function() logoutRequested,
    required TResult Function() sessionExpiringWarningReceived,
  }) {
    return logoutRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult? Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult? Function()? checkAuthStatus,
    TResult? Function()? logoutRequested,
    TResult? Function()? sessionExpiringWarningReceived,
  }) {
    return logoutRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult Function()? checkAuthStatus,
    TResult Function()? logoutRequested,
    TResult Function()? sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (logoutRequested != null) {
      return logoutRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(RegisterSubmitted value) registerSubmitted,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(LogoutRequested value) logoutRequested,
    required TResult Function(SessionExpiringWarningReceived value)
    sessionExpiringWarningReceived,
  }) {
    return logoutRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(RegisterSubmitted value)? registerSubmitted,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(LogoutRequested value)? logoutRequested,
    TResult? Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
  }) {
    return logoutRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(RegisterSubmitted value)? registerSubmitted,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(LogoutRequested value)? logoutRequested,
    TResult Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (logoutRequested != null) {
      return logoutRequested(this);
    }
    return orElse();
  }
}

abstract class LogoutRequested implements AuthEvent {
  const factory LogoutRequested() = _$LogoutRequestedImpl;
}

/// @nodoc
abstract class _$$SessionExpiringWarningReceivedImplCopyWith<$Res> {
  factory _$$SessionExpiringWarningReceivedImplCopyWith(
    _$SessionExpiringWarningReceivedImpl value,
    $Res Function(_$SessionExpiringWarningReceivedImpl) then,
  ) = __$$SessionExpiringWarningReceivedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SessionExpiringWarningReceivedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SessionExpiringWarningReceivedImpl>
    implements _$$SessionExpiringWarningReceivedImplCopyWith<$Res> {
  __$$SessionExpiringWarningReceivedImplCopyWithImpl(
    _$SessionExpiringWarningReceivedImpl _value,
    $Res Function(_$SessionExpiringWarningReceivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SessionExpiringWarningReceivedImpl
    implements SessionExpiringWarningReceived {
  const _$SessionExpiringWarningReceivedImpl();

  @override
  String toString() {
    return 'AuthEvent.sessionExpiringWarningReceived()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionExpiringWarningReceivedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    loginSubmitted,
    required TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )
    registerSubmitted,
    required TResult Function() checkAuthStatus,
    required TResult Function() logoutRequested,
    required TResult Function() sessionExpiringWarningReceived,
  }) {
    return sessionExpiringWarningReceived();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult? Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult? Function()? checkAuthStatus,
    TResult? Function()? logoutRequested,
    TResult? Function()? sessionExpiringWarningReceived,
  }) {
    return sessionExpiringWarningReceived?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)?
    loginSubmitted,
    TResult Function(
      String email,
      String password,
      String name,
      bool subscribeToNewsletter,
    )?
    registerSubmitted,
    TResult Function()? checkAuthStatus,
    TResult Function()? logoutRequested,
    TResult Function()? sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (sessionExpiringWarningReceived != null) {
      return sessionExpiringWarningReceived();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginSubmitted value) loginSubmitted,
    required TResult Function(RegisterSubmitted value) registerSubmitted,
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(LogoutRequested value) logoutRequested,
    required TResult Function(SessionExpiringWarningReceived value)
    sessionExpiringWarningReceived,
  }) {
    return sessionExpiringWarningReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginSubmitted value)? loginSubmitted,
    TResult? Function(RegisterSubmitted value)? registerSubmitted,
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(LogoutRequested value)? logoutRequested,
    TResult? Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
  }) {
    return sessionExpiringWarningReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginSubmitted value)? loginSubmitted,
    TResult Function(RegisterSubmitted value)? registerSubmitted,
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(LogoutRequested value)? logoutRequested,
    TResult Function(SessionExpiringWarningReceived value)?
    sessionExpiringWarningReceived,
    required TResult orElse(),
  }) {
    if (sessionExpiringWarningReceived != null) {
      return sessionExpiringWarningReceived(this);
    }
    return orElse();
  }
}

abstract class SessionExpiringWarningReceived implements AuthEvent {
  const factory SessionExpiringWarningReceived() =
      _$SessionExpiringWarningReceivedImpl;
}
