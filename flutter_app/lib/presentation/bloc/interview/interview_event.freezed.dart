// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interview_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$InterviewEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInterviewSessions,
    required TResult Function(String sessionId) loadInterviewSession,
    required TResult Function(String companyName, String role)
    generateInterview,
    required TResult Function(
      String sessionId,
      String questionId,
      String answer,
    )
    submitAnswer,
    required TResult Function(String sessionId) completeInterview,
    required TResult Function(String sessionId) loadInterviewResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInterviewSessions,
    TResult? Function(String sessionId)? loadInterviewSession,
    TResult? Function(String companyName, String role)? generateInterview,
    TResult? Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult? Function(String sessionId)? completeInterview,
    TResult? Function(String sessionId)? loadInterviewResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInterviewSessions,
    TResult Function(String sessionId)? loadInterviewSession,
    TResult Function(String companyName, String role)? generateInterview,
    TResult Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult Function(String sessionId)? completeInterview,
    TResult Function(String sessionId)? loadInterviewResult,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadInterviewSessions value)
    loadInterviewSessions,
    required TResult Function(LoadInterviewSession value) loadInterviewSession,
    required TResult Function(GenerateInterview value) generateInterview,
    required TResult Function(SubmitAnswer value) submitAnswer,
    required TResult Function(CompleteInterview value) completeInterview,
    required TResult Function(LoadInterviewResult value) loadInterviewResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult? Function(LoadInterviewSession value)? loadInterviewSession,
    TResult? Function(GenerateInterview value)? generateInterview,
    TResult? Function(SubmitAnswer value)? submitAnswer,
    TResult? Function(CompleteInterview value)? completeInterview,
    TResult? Function(LoadInterviewResult value)? loadInterviewResult,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult Function(LoadInterviewSession value)? loadInterviewSession,
    TResult Function(GenerateInterview value)? generateInterview,
    TResult Function(SubmitAnswer value)? submitAnswer,
    TResult Function(CompleteInterview value)? completeInterview,
    TResult Function(LoadInterviewResult value)? loadInterviewResult,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterviewEventCopyWith<$Res> {
  factory $InterviewEventCopyWith(
    InterviewEvent value,
    $Res Function(InterviewEvent) then,
  ) = _$InterviewEventCopyWithImpl<$Res, InterviewEvent>;
}

/// @nodoc
class _$InterviewEventCopyWithImpl<$Res, $Val extends InterviewEvent>
    implements $InterviewEventCopyWith<$Res> {
  _$InterviewEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadInterviewSessionsImplCopyWith<$Res> {
  factory _$$LoadInterviewSessionsImplCopyWith(
    _$LoadInterviewSessionsImpl value,
    $Res Function(_$LoadInterviewSessionsImpl) then,
  ) = __$$LoadInterviewSessionsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadInterviewSessionsImplCopyWithImpl<$Res>
    extends _$InterviewEventCopyWithImpl<$Res, _$LoadInterviewSessionsImpl>
    implements _$$LoadInterviewSessionsImplCopyWith<$Res> {
  __$$LoadInterviewSessionsImplCopyWithImpl(
    _$LoadInterviewSessionsImpl _value,
    $Res Function(_$LoadInterviewSessionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadInterviewSessionsImpl implements LoadInterviewSessions {
  const _$LoadInterviewSessionsImpl();

  @override
  String toString() {
    return 'InterviewEvent.loadInterviewSessions()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadInterviewSessionsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInterviewSessions,
    required TResult Function(String sessionId) loadInterviewSession,
    required TResult Function(String companyName, String role)
    generateInterview,
    required TResult Function(
      String sessionId,
      String questionId,
      String answer,
    )
    submitAnswer,
    required TResult Function(String sessionId) completeInterview,
    required TResult Function(String sessionId) loadInterviewResult,
  }) {
    return loadInterviewSessions();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInterviewSessions,
    TResult? Function(String sessionId)? loadInterviewSession,
    TResult? Function(String companyName, String role)? generateInterview,
    TResult? Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult? Function(String sessionId)? completeInterview,
    TResult? Function(String sessionId)? loadInterviewResult,
  }) {
    return loadInterviewSessions?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInterviewSessions,
    TResult Function(String sessionId)? loadInterviewSession,
    TResult Function(String companyName, String role)? generateInterview,
    TResult Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult Function(String sessionId)? completeInterview,
    TResult Function(String sessionId)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (loadInterviewSessions != null) {
      return loadInterviewSessions();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadInterviewSessions value)
    loadInterviewSessions,
    required TResult Function(LoadInterviewSession value) loadInterviewSession,
    required TResult Function(GenerateInterview value) generateInterview,
    required TResult Function(SubmitAnswer value) submitAnswer,
    required TResult Function(CompleteInterview value) completeInterview,
    required TResult Function(LoadInterviewResult value) loadInterviewResult,
  }) {
    return loadInterviewSessions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult? Function(LoadInterviewSession value)? loadInterviewSession,
    TResult? Function(GenerateInterview value)? generateInterview,
    TResult? Function(SubmitAnswer value)? submitAnswer,
    TResult? Function(CompleteInterview value)? completeInterview,
    TResult? Function(LoadInterviewResult value)? loadInterviewResult,
  }) {
    return loadInterviewSessions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult Function(LoadInterviewSession value)? loadInterviewSession,
    TResult Function(GenerateInterview value)? generateInterview,
    TResult Function(SubmitAnswer value)? submitAnswer,
    TResult Function(CompleteInterview value)? completeInterview,
    TResult Function(LoadInterviewResult value)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (loadInterviewSessions != null) {
      return loadInterviewSessions(this);
    }
    return orElse();
  }
}

abstract class LoadInterviewSessions implements InterviewEvent {
  const factory LoadInterviewSessions() = _$LoadInterviewSessionsImpl;
}

/// @nodoc
abstract class _$$LoadInterviewSessionImplCopyWith<$Res> {
  factory _$$LoadInterviewSessionImplCopyWith(
    _$LoadInterviewSessionImpl value,
    $Res Function(_$LoadInterviewSessionImpl) then,
  ) = __$$LoadInterviewSessionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sessionId});
}

/// @nodoc
class __$$LoadInterviewSessionImplCopyWithImpl<$Res>
    extends _$InterviewEventCopyWithImpl<$Res, _$LoadInterviewSessionImpl>
    implements _$$LoadInterviewSessionImplCopyWith<$Res> {
  __$$LoadInterviewSessionImplCopyWithImpl(
    _$LoadInterviewSessionImpl _value,
    $Res Function(_$LoadInterviewSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionId = null}) {
    return _then(
      _$LoadInterviewSessionImpl(
        null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadInterviewSessionImpl implements LoadInterviewSession {
  const _$LoadInterviewSessionImpl(this.sessionId);

  @override
  final String sessionId;

  @override
  String toString() {
    return 'InterviewEvent.loadInterviewSession(sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadInterviewSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadInterviewSessionImplCopyWith<_$LoadInterviewSessionImpl>
  get copyWith =>
      __$$LoadInterviewSessionImplCopyWithImpl<_$LoadInterviewSessionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInterviewSessions,
    required TResult Function(String sessionId) loadInterviewSession,
    required TResult Function(String companyName, String role)
    generateInterview,
    required TResult Function(
      String sessionId,
      String questionId,
      String answer,
    )
    submitAnswer,
    required TResult Function(String sessionId) completeInterview,
    required TResult Function(String sessionId) loadInterviewResult,
  }) {
    return loadInterviewSession(sessionId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInterviewSessions,
    TResult? Function(String sessionId)? loadInterviewSession,
    TResult? Function(String companyName, String role)? generateInterview,
    TResult? Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult? Function(String sessionId)? completeInterview,
    TResult? Function(String sessionId)? loadInterviewResult,
  }) {
    return loadInterviewSession?.call(sessionId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInterviewSessions,
    TResult Function(String sessionId)? loadInterviewSession,
    TResult Function(String companyName, String role)? generateInterview,
    TResult Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult Function(String sessionId)? completeInterview,
    TResult Function(String sessionId)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (loadInterviewSession != null) {
      return loadInterviewSession(sessionId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadInterviewSessions value)
    loadInterviewSessions,
    required TResult Function(LoadInterviewSession value) loadInterviewSession,
    required TResult Function(GenerateInterview value) generateInterview,
    required TResult Function(SubmitAnswer value) submitAnswer,
    required TResult Function(CompleteInterview value) completeInterview,
    required TResult Function(LoadInterviewResult value) loadInterviewResult,
  }) {
    return loadInterviewSession(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult? Function(LoadInterviewSession value)? loadInterviewSession,
    TResult? Function(GenerateInterview value)? generateInterview,
    TResult? Function(SubmitAnswer value)? submitAnswer,
    TResult? Function(CompleteInterview value)? completeInterview,
    TResult? Function(LoadInterviewResult value)? loadInterviewResult,
  }) {
    return loadInterviewSession?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult Function(LoadInterviewSession value)? loadInterviewSession,
    TResult Function(GenerateInterview value)? generateInterview,
    TResult Function(SubmitAnswer value)? submitAnswer,
    TResult Function(CompleteInterview value)? completeInterview,
    TResult Function(LoadInterviewResult value)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (loadInterviewSession != null) {
      return loadInterviewSession(this);
    }
    return orElse();
  }
}

abstract class LoadInterviewSession implements InterviewEvent {
  const factory LoadInterviewSession(final String sessionId) =
      _$LoadInterviewSessionImpl;

  String get sessionId;

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadInterviewSessionImplCopyWith<_$LoadInterviewSessionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GenerateInterviewImplCopyWith<$Res> {
  factory _$$GenerateInterviewImplCopyWith(
    _$GenerateInterviewImpl value,
    $Res Function(_$GenerateInterviewImpl) then,
  ) = __$$GenerateInterviewImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String companyName, String role});
}

/// @nodoc
class __$$GenerateInterviewImplCopyWithImpl<$Res>
    extends _$InterviewEventCopyWithImpl<$Res, _$GenerateInterviewImpl>
    implements _$$GenerateInterviewImplCopyWith<$Res> {
  __$$GenerateInterviewImplCopyWithImpl(
    _$GenerateInterviewImpl _value,
    $Res Function(_$GenerateInterviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? companyName = null, Object? role = null}) {
    return _then(
      _$GenerateInterviewImpl(
        null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GenerateInterviewImpl implements GenerateInterview {
  const _$GenerateInterviewImpl(this.companyName, this.role);

  @override
  final String companyName;
  @override
  final String role;

  @override
  String toString() {
    return 'InterviewEvent.generateInterview(companyName: $companyName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateInterviewImpl &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, companyName, role);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateInterviewImplCopyWith<_$GenerateInterviewImpl> get copyWith =>
      __$$GenerateInterviewImplCopyWithImpl<_$GenerateInterviewImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInterviewSessions,
    required TResult Function(String sessionId) loadInterviewSession,
    required TResult Function(String companyName, String role)
    generateInterview,
    required TResult Function(
      String sessionId,
      String questionId,
      String answer,
    )
    submitAnswer,
    required TResult Function(String sessionId) completeInterview,
    required TResult Function(String sessionId) loadInterviewResult,
  }) {
    return generateInterview(companyName, role);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInterviewSessions,
    TResult? Function(String sessionId)? loadInterviewSession,
    TResult? Function(String companyName, String role)? generateInterview,
    TResult? Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult? Function(String sessionId)? completeInterview,
    TResult? Function(String sessionId)? loadInterviewResult,
  }) {
    return generateInterview?.call(companyName, role);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInterviewSessions,
    TResult Function(String sessionId)? loadInterviewSession,
    TResult Function(String companyName, String role)? generateInterview,
    TResult Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult Function(String sessionId)? completeInterview,
    TResult Function(String sessionId)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (generateInterview != null) {
      return generateInterview(companyName, role);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadInterviewSessions value)
    loadInterviewSessions,
    required TResult Function(LoadInterviewSession value) loadInterviewSession,
    required TResult Function(GenerateInterview value) generateInterview,
    required TResult Function(SubmitAnswer value) submitAnswer,
    required TResult Function(CompleteInterview value) completeInterview,
    required TResult Function(LoadInterviewResult value) loadInterviewResult,
  }) {
    return generateInterview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult? Function(LoadInterviewSession value)? loadInterviewSession,
    TResult? Function(GenerateInterview value)? generateInterview,
    TResult? Function(SubmitAnswer value)? submitAnswer,
    TResult? Function(CompleteInterview value)? completeInterview,
    TResult? Function(LoadInterviewResult value)? loadInterviewResult,
  }) {
    return generateInterview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult Function(LoadInterviewSession value)? loadInterviewSession,
    TResult Function(GenerateInterview value)? generateInterview,
    TResult Function(SubmitAnswer value)? submitAnswer,
    TResult Function(CompleteInterview value)? completeInterview,
    TResult Function(LoadInterviewResult value)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (generateInterview != null) {
      return generateInterview(this);
    }
    return orElse();
  }
}

abstract class GenerateInterview implements InterviewEvent {
  const factory GenerateInterview(final String companyName, final String role) =
      _$GenerateInterviewImpl;

  String get companyName;
  String get role;

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerateInterviewImplCopyWith<_$GenerateInterviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SubmitAnswerImplCopyWith<$Res> {
  factory _$$SubmitAnswerImplCopyWith(
    _$SubmitAnswerImpl value,
    $Res Function(_$SubmitAnswerImpl) then,
  ) = __$$SubmitAnswerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sessionId, String questionId, String answer});
}

/// @nodoc
class __$$SubmitAnswerImplCopyWithImpl<$Res>
    extends _$InterviewEventCopyWithImpl<$Res, _$SubmitAnswerImpl>
    implements _$$SubmitAnswerImplCopyWith<$Res> {
  __$$SubmitAnswerImplCopyWithImpl(
    _$SubmitAnswerImpl _value,
    $Res Function(_$SubmitAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? questionId = null,
    Object? answer = null,
  }) {
    return _then(
      _$SubmitAnswerImpl(
        null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == answer
            ? _value.answer
            : answer // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SubmitAnswerImpl implements SubmitAnswer {
  const _$SubmitAnswerImpl(this.sessionId, this.questionId, this.answer);

  @override
  final String sessionId;
  @override
  final String questionId;
  @override
  final String answer;

  @override
  String toString() {
    return 'InterviewEvent.submitAnswer(sessionId: $sessionId, questionId: $questionId, answer: $answer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitAnswerImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.answer, answer) || other.answer == answer));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, questionId, answer);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitAnswerImplCopyWith<_$SubmitAnswerImpl> get copyWith =>
      __$$SubmitAnswerImplCopyWithImpl<_$SubmitAnswerImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInterviewSessions,
    required TResult Function(String sessionId) loadInterviewSession,
    required TResult Function(String companyName, String role)
    generateInterview,
    required TResult Function(
      String sessionId,
      String questionId,
      String answer,
    )
    submitAnswer,
    required TResult Function(String sessionId) completeInterview,
    required TResult Function(String sessionId) loadInterviewResult,
  }) {
    return submitAnswer(sessionId, questionId, answer);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInterviewSessions,
    TResult? Function(String sessionId)? loadInterviewSession,
    TResult? Function(String companyName, String role)? generateInterview,
    TResult? Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult? Function(String sessionId)? completeInterview,
    TResult? Function(String sessionId)? loadInterviewResult,
  }) {
    return submitAnswer?.call(sessionId, questionId, answer);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInterviewSessions,
    TResult Function(String sessionId)? loadInterviewSession,
    TResult Function(String companyName, String role)? generateInterview,
    TResult Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult Function(String sessionId)? completeInterview,
    TResult Function(String sessionId)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (submitAnswer != null) {
      return submitAnswer(sessionId, questionId, answer);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadInterviewSessions value)
    loadInterviewSessions,
    required TResult Function(LoadInterviewSession value) loadInterviewSession,
    required TResult Function(GenerateInterview value) generateInterview,
    required TResult Function(SubmitAnswer value) submitAnswer,
    required TResult Function(CompleteInterview value) completeInterview,
    required TResult Function(LoadInterviewResult value) loadInterviewResult,
  }) {
    return submitAnswer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult? Function(LoadInterviewSession value)? loadInterviewSession,
    TResult? Function(GenerateInterview value)? generateInterview,
    TResult? Function(SubmitAnswer value)? submitAnswer,
    TResult? Function(CompleteInterview value)? completeInterview,
    TResult? Function(LoadInterviewResult value)? loadInterviewResult,
  }) {
    return submitAnswer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult Function(LoadInterviewSession value)? loadInterviewSession,
    TResult Function(GenerateInterview value)? generateInterview,
    TResult Function(SubmitAnswer value)? submitAnswer,
    TResult Function(CompleteInterview value)? completeInterview,
    TResult Function(LoadInterviewResult value)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (submitAnswer != null) {
      return submitAnswer(this);
    }
    return orElse();
  }
}

abstract class SubmitAnswer implements InterviewEvent {
  const factory SubmitAnswer(
    final String sessionId,
    final String questionId,
    final String answer,
  ) = _$SubmitAnswerImpl;

  String get sessionId;
  String get questionId;
  String get answer;

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitAnswerImplCopyWith<_$SubmitAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompleteInterviewImplCopyWith<$Res> {
  factory _$$CompleteInterviewImplCopyWith(
    _$CompleteInterviewImpl value,
    $Res Function(_$CompleteInterviewImpl) then,
  ) = __$$CompleteInterviewImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sessionId});
}

/// @nodoc
class __$$CompleteInterviewImplCopyWithImpl<$Res>
    extends _$InterviewEventCopyWithImpl<$Res, _$CompleteInterviewImpl>
    implements _$$CompleteInterviewImplCopyWith<$Res> {
  __$$CompleteInterviewImplCopyWithImpl(
    _$CompleteInterviewImpl _value,
    $Res Function(_$CompleteInterviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionId = null}) {
    return _then(
      _$CompleteInterviewImpl(
        null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CompleteInterviewImpl implements CompleteInterview {
  const _$CompleteInterviewImpl(this.sessionId);

  @override
  final String sessionId;

  @override
  String toString() {
    return 'InterviewEvent.completeInterview(sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteInterviewImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteInterviewImplCopyWith<_$CompleteInterviewImpl> get copyWith =>
      __$$CompleteInterviewImplCopyWithImpl<_$CompleteInterviewImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInterviewSessions,
    required TResult Function(String sessionId) loadInterviewSession,
    required TResult Function(String companyName, String role)
    generateInterview,
    required TResult Function(
      String sessionId,
      String questionId,
      String answer,
    )
    submitAnswer,
    required TResult Function(String sessionId) completeInterview,
    required TResult Function(String sessionId) loadInterviewResult,
  }) {
    return completeInterview(sessionId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInterviewSessions,
    TResult? Function(String sessionId)? loadInterviewSession,
    TResult? Function(String companyName, String role)? generateInterview,
    TResult? Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult? Function(String sessionId)? completeInterview,
    TResult? Function(String sessionId)? loadInterviewResult,
  }) {
    return completeInterview?.call(sessionId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInterviewSessions,
    TResult Function(String sessionId)? loadInterviewSession,
    TResult Function(String companyName, String role)? generateInterview,
    TResult Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult Function(String sessionId)? completeInterview,
    TResult Function(String sessionId)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (completeInterview != null) {
      return completeInterview(sessionId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadInterviewSessions value)
    loadInterviewSessions,
    required TResult Function(LoadInterviewSession value) loadInterviewSession,
    required TResult Function(GenerateInterview value) generateInterview,
    required TResult Function(SubmitAnswer value) submitAnswer,
    required TResult Function(CompleteInterview value) completeInterview,
    required TResult Function(LoadInterviewResult value) loadInterviewResult,
  }) {
    return completeInterview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult? Function(LoadInterviewSession value)? loadInterviewSession,
    TResult? Function(GenerateInterview value)? generateInterview,
    TResult? Function(SubmitAnswer value)? submitAnswer,
    TResult? Function(CompleteInterview value)? completeInterview,
    TResult? Function(LoadInterviewResult value)? loadInterviewResult,
  }) {
    return completeInterview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult Function(LoadInterviewSession value)? loadInterviewSession,
    TResult Function(GenerateInterview value)? generateInterview,
    TResult Function(SubmitAnswer value)? submitAnswer,
    TResult Function(CompleteInterview value)? completeInterview,
    TResult Function(LoadInterviewResult value)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (completeInterview != null) {
      return completeInterview(this);
    }
    return orElse();
  }
}

abstract class CompleteInterview implements InterviewEvent {
  const factory CompleteInterview(final String sessionId) =
      _$CompleteInterviewImpl;

  String get sessionId;

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompleteInterviewImplCopyWith<_$CompleteInterviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadInterviewResultImplCopyWith<$Res> {
  factory _$$LoadInterviewResultImplCopyWith(
    _$LoadInterviewResultImpl value,
    $Res Function(_$LoadInterviewResultImpl) then,
  ) = __$$LoadInterviewResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sessionId});
}

/// @nodoc
class __$$LoadInterviewResultImplCopyWithImpl<$Res>
    extends _$InterviewEventCopyWithImpl<$Res, _$LoadInterviewResultImpl>
    implements _$$LoadInterviewResultImplCopyWith<$Res> {
  __$$LoadInterviewResultImplCopyWithImpl(
    _$LoadInterviewResultImpl _value,
    $Res Function(_$LoadInterviewResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sessionId = null}) {
    return _then(
      _$LoadInterviewResultImpl(
        null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadInterviewResultImpl implements LoadInterviewResult {
  const _$LoadInterviewResultImpl(this.sessionId);

  @override
  final String sessionId;

  @override
  String toString() {
    return 'InterviewEvent.loadInterviewResult(sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadInterviewResultImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId);

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadInterviewResultImplCopyWith<_$LoadInterviewResultImpl> get copyWith =>
      __$$LoadInterviewResultImplCopyWithImpl<_$LoadInterviewResultImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInterviewSessions,
    required TResult Function(String sessionId) loadInterviewSession,
    required TResult Function(String companyName, String role)
    generateInterview,
    required TResult Function(
      String sessionId,
      String questionId,
      String answer,
    )
    submitAnswer,
    required TResult Function(String sessionId) completeInterview,
    required TResult Function(String sessionId) loadInterviewResult,
  }) {
    return loadInterviewResult(sessionId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInterviewSessions,
    TResult? Function(String sessionId)? loadInterviewSession,
    TResult? Function(String companyName, String role)? generateInterview,
    TResult? Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult? Function(String sessionId)? completeInterview,
    TResult? Function(String sessionId)? loadInterviewResult,
  }) {
    return loadInterviewResult?.call(sessionId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInterviewSessions,
    TResult Function(String sessionId)? loadInterviewSession,
    TResult Function(String companyName, String role)? generateInterview,
    TResult Function(String sessionId, String questionId, String answer)?
    submitAnswer,
    TResult Function(String sessionId)? completeInterview,
    TResult Function(String sessionId)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (loadInterviewResult != null) {
      return loadInterviewResult(sessionId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadInterviewSessions value)
    loadInterviewSessions,
    required TResult Function(LoadInterviewSession value) loadInterviewSession,
    required TResult Function(GenerateInterview value) generateInterview,
    required TResult Function(SubmitAnswer value) submitAnswer,
    required TResult Function(CompleteInterview value) completeInterview,
    required TResult Function(LoadInterviewResult value) loadInterviewResult,
  }) {
    return loadInterviewResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult? Function(LoadInterviewSession value)? loadInterviewSession,
    TResult? Function(GenerateInterview value)? generateInterview,
    TResult? Function(SubmitAnswer value)? submitAnswer,
    TResult? Function(CompleteInterview value)? completeInterview,
    TResult? Function(LoadInterviewResult value)? loadInterviewResult,
  }) {
    return loadInterviewResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadInterviewSessions value)? loadInterviewSessions,
    TResult Function(LoadInterviewSession value)? loadInterviewSession,
    TResult Function(GenerateInterview value)? generateInterview,
    TResult Function(SubmitAnswer value)? submitAnswer,
    TResult Function(CompleteInterview value)? completeInterview,
    TResult Function(LoadInterviewResult value)? loadInterviewResult,
    required TResult orElse(),
  }) {
    if (loadInterviewResult != null) {
      return loadInterviewResult(this);
    }
    return orElse();
  }
}

abstract class LoadInterviewResult implements InterviewEvent {
  const factory LoadInterviewResult(final String sessionId) =
      _$LoadInterviewResultImpl;

  String get sessionId;

  /// Create a copy of InterviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadInterviewResultImplCopyWith<_$LoadInterviewResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
