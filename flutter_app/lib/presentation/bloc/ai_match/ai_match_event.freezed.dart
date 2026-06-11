// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_match_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AiMatchEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadMatches,
    required TResult Function(String resumeId, String jobDescription)
    matchResumeToJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadMatches,
    TResult? Function(String resumeId, String jobDescription)? matchResumeToJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadMatches,
    TResult Function(String resumeId, String jobDescription)? matchResumeToJob,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadMatches value) loadMatches,
    required TResult Function(MatchResumeToJob value) matchResumeToJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadMatches value)? loadMatches,
    TResult? Function(MatchResumeToJob value)? matchResumeToJob,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadMatches value)? loadMatches,
    TResult Function(MatchResumeToJob value)? matchResumeToJob,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiMatchEventCopyWith<$Res> {
  factory $AiMatchEventCopyWith(
    AiMatchEvent value,
    $Res Function(AiMatchEvent) then,
  ) = _$AiMatchEventCopyWithImpl<$Res, AiMatchEvent>;
}

/// @nodoc
class _$AiMatchEventCopyWithImpl<$Res, $Val extends AiMatchEvent>
    implements $AiMatchEventCopyWith<$Res> {
  _$AiMatchEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiMatchEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadMatchesImplCopyWith<$Res> {
  factory _$$LoadMatchesImplCopyWith(
    _$LoadMatchesImpl value,
    $Res Function(_$LoadMatchesImpl) then,
  ) = __$$LoadMatchesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadMatchesImplCopyWithImpl<$Res>
    extends _$AiMatchEventCopyWithImpl<$Res, _$LoadMatchesImpl>
    implements _$$LoadMatchesImplCopyWith<$Res> {
  __$$LoadMatchesImplCopyWithImpl(
    _$LoadMatchesImpl _value,
    $Res Function(_$LoadMatchesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiMatchEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadMatchesImpl implements LoadMatches {
  const _$LoadMatchesImpl();

  @override
  String toString() {
    return 'AiMatchEvent.loadMatches()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadMatchesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadMatches,
    required TResult Function(String resumeId, String jobDescription)
    matchResumeToJob,
  }) {
    return loadMatches();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadMatches,
    TResult? Function(String resumeId, String jobDescription)? matchResumeToJob,
  }) {
    return loadMatches?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadMatches,
    TResult Function(String resumeId, String jobDescription)? matchResumeToJob,
    required TResult orElse(),
  }) {
    if (loadMatches != null) {
      return loadMatches();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadMatches value) loadMatches,
    required TResult Function(MatchResumeToJob value) matchResumeToJob,
  }) {
    return loadMatches(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadMatches value)? loadMatches,
    TResult? Function(MatchResumeToJob value)? matchResumeToJob,
  }) {
    return loadMatches?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadMatches value)? loadMatches,
    TResult Function(MatchResumeToJob value)? matchResumeToJob,
    required TResult orElse(),
  }) {
    if (loadMatches != null) {
      return loadMatches(this);
    }
    return orElse();
  }
}

abstract class LoadMatches implements AiMatchEvent {
  const factory LoadMatches() = _$LoadMatchesImpl;
}

/// @nodoc
abstract class _$$MatchResumeToJobImplCopyWith<$Res> {
  factory _$$MatchResumeToJobImplCopyWith(
    _$MatchResumeToJobImpl value,
    $Res Function(_$MatchResumeToJobImpl) then,
  ) = __$$MatchResumeToJobImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String resumeId, String jobDescription});
}

/// @nodoc
class __$$MatchResumeToJobImplCopyWithImpl<$Res>
    extends _$AiMatchEventCopyWithImpl<$Res, _$MatchResumeToJobImpl>
    implements _$$MatchResumeToJobImplCopyWith<$Res> {
  __$$MatchResumeToJobImplCopyWithImpl(
    _$MatchResumeToJobImpl _value,
    $Res Function(_$MatchResumeToJobImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? resumeId = null, Object? jobDescription = null}) {
    return _then(
      _$MatchResumeToJobImpl(
        null == resumeId
            ? _value.resumeId
            : resumeId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == jobDescription
            ? _value.jobDescription
            : jobDescription // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MatchResumeToJobImpl implements MatchResumeToJob {
  const _$MatchResumeToJobImpl(this.resumeId, this.jobDescription);

  @override
  final String resumeId;
  @override
  final String jobDescription;

  @override
  String toString() {
    return 'AiMatchEvent.matchResumeToJob(resumeId: $resumeId, jobDescription: $jobDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchResumeToJobImpl &&
            (identical(other.resumeId, resumeId) ||
                other.resumeId == resumeId) &&
            (identical(other.jobDescription, jobDescription) ||
                other.jobDescription == jobDescription));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resumeId, jobDescription);

  /// Create a copy of AiMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchResumeToJobImplCopyWith<_$MatchResumeToJobImpl> get copyWith =>
      __$$MatchResumeToJobImplCopyWithImpl<_$MatchResumeToJobImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadMatches,
    required TResult Function(String resumeId, String jobDescription)
    matchResumeToJob,
  }) {
    return matchResumeToJob(resumeId, jobDescription);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadMatches,
    TResult? Function(String resumeId, String jobDescription)? matchResumeToJob,
  }) {
    return matchResumeToJob?.call(resumeId, jobDescription);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadMatches,
    TResult Function(String resumeId, String jobDescription)? matchResumeToJob,
    required TResult orElse(),
  }) {
    if (matchResumeToJob != null) {
      return matchResumeToJob(resumeId, jobDescription);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadMatches value) loadMatches,
    required TResult Function(MatchResumeToJob value) matchResumeToJob,
  }) {
    return matchResumeToJob(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadMatches value)? loadMatches,
    TResult? Function(MatchResumeToJob value)? matchResumeToJob,
  }) {
    return matchResumeToJob?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadMatches value)? loadMatches,
    TResult Function(MatchResumeToJob value)? matchResumeToJob,
    required TResult orElse(),
  }) {
    if (matchResumeToJob != null) {
      return matchResumeToJob(this);
    }
    return orElse();
  }
}

abstract class MatchResumeToJob implements AiMatchEvent {
  const factory MatchResumeToJob(
    final String resumeId,
    final String jobDescription,
  ) = _$MatchResumeToJobImpl;

  String get resumeId;
  String get jobDescription;

  /// Create a copy of AiMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchResumeToJobImplCopyWith<_$MatchResumeToJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
