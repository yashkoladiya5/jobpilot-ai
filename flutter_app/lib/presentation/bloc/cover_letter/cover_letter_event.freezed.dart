// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cover_letter_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CoverLetterEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )
    generateCoverLetter,
    required TResult Function() loadCoverLetters,
    required TResult Function(String id) loadCoverLetter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult? Function()? loadCoverLetters,
    TResult? Function(String id)? loadCoverLetter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult Function()? loadCoverLetters,
    TResult Function(String id)? loadCoverLetter,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateCoverLetter value) generateCoverLetter,
    required TResult Function(LoadCoverLetters value) loadCoverLetters,
    required TResult Function(LoadCoverLetter value) loadCoverLetter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult? Function(LoadCoverLetters value)? loadCoverLetters,
    TResult? Function(LoadCoverLetter value)? loadCoverLetter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult Function(LoadCoverLetters value)? loadCoverLetters,
    TResult Function(LoadCoverLetter value)? loadCoverLetter,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoverLetterEventCopyWith<$Res> {
  factory $CoverLetterEventCopyWith(
    CoverLetterEvent value,
    $Res Function(CoverLetterEvent) then,
  ) = _$CoverLetterEventCopyWithImpl<$Res, CoverLetterEvent>;
}

/// @nodoc
class _$CoverLetterEventCopyWithImpl<$Res, $Val extends CoverLetterEvent>
    implements $CoverLetterEventCopyWith<$Res> {
  _$CoverLetterEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GenerateCoverLetterImplCopyWith<$Res> {
  factory _$$GenerateCoverLetterImplCopyWith(
    _$GenerateCoverLetterImpl value,
    $Res Function(_$GenerateCoverLetterImpl) then,
  ) = __$$GenerateCoverLetterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String resumeId,
    String jobDescription,
    String? jobId,
    String? tone,
  });
}

/// @nodoc
class __$$GenerateCoverLetterImplCopyWithImpl<$Res>
    extends _$CoverLetterEventCopyWithImpl<$Res, _$GenerateCoverLetterImpl>
    implements _$$GenerateCoverLetterImplCopyWith<$Res> {
  __$$GenerateCoverLetterImplCopyWithImpl(
    _$GenerateCoverLetterImpl _value,
    $Res Function(_$GenerateCoverLetterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resumeId = null,
    Object? jobDescription = null,
    Object? jobId = freezed,
    Object? tone = freezed,
  }) {
    return _then(
      _$GenerateCoverLetterImpl(
        null == resumeId
            ? _value.resumeId
            : resumeId // ignore: cast_nullable_to_non_nullable
                  as String,
        null == jobDescription
            ? _value.jobDescription
            : jobDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        jobId: freezed == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tone: freezed == tone
            ? _value.tone
            : tone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$GenerateCoverLetterImpl implements GenerateCoverLetter {
  const _$GenerateCoverLetterImpl(
    this.resumeId,
    this.jobDescription, {
    this.jobId,
    this.tone,
  });

  @override
  final String resumeId;
  @override
  final String jobDescription;
  @override
  final String? jobId;
  @override
  final String? tone;

  @override
  String toString() {
    return 'CoverLetterEvent.generateCoverLetter(resumeId: $resumeId, jobDescription: $jobDescription, jobId: $jobId, tone: $tone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateCoverLetterImpl &&
            (identical(other.resumeId, resumeId) ||
                other.resumeId == resumeId) &&
            (identical(other.jobDescription, jobDescription) ||
                other.jobDescription == jobDescription) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.tone, tone) || other.tone == tone));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, resumeId, jobDescription, jobId, tone);

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateCoverLetterImplCopyWith<_$GenerateCoverLetterImpl> get copyWith =>
      __$$GenerateCoverLetterImplCopyWithImpl<_$GenerateCoverLetterImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )
    generateCoverLetter,
    required TResult Function() loadCoverLetters,
    required TResult Function(String id) loadCoverLetter,
  }) {
    return generateCoverLetter(resumeId, jobDescription, jobId, tone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult? Function()? loadCoverLetters,
    TResult? Function(String id)? loadCoverLetter,
  }) {
    return generateCoverLetter?.call(resumeId, jobDescription, jobId, tone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult Function()? loadCoverLetters,
    TResult Function(String id)? loadCoverLetter,
    required TResult orElse(),
  }) {
    if (generateCoverLetter != null) {
      return generateCoverLetter(resumeId, jobDescription, jobId, tone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateCoverLetter value) generateCoverLetter,
    required TResult Function(LoadCoverLetters value) loadCoverLetters,
    required TResult Function(LoadCoverLetter value) loadCoverLetter,
  }) {
    return generateCoverLetter(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult? Function(LoadCoverLetters value)? loadCoverLetters,
    TResult? Function(LoadCoverLetter value)? loadCoverLetter,
  }) {
    return generateCoverLetter?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult Function(LoadCoverLetters value)? loadCoverLetters,
    TResult Function(LoadCoverLetter value)? loadCoverLetter,
    required TResult orElse(),
  }) {
    if (generateCoverLetter != null) {
      return generateCoverLetter(this);
    }
    return orElse();
  }
}

abstract class GenerateCoverLetter implements CoverLetterEvent {
  const factory GenerateCoverLetter(
    final String resumeId,
    final String jobDescription, {
    final String? jobId,
    final String? tone,
  }) = _$GenerateCoverLetterImpl;

  String get resumeId;
  String get jobDescription;
  String? get jobId;
  String? get tone;

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerateCoverLetterImplCopyWith<_$GenerateCoverLetterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadCoverLettersImplCopyWith<$Res> {
  factory _$$LoadCoverLettersImplCopyWith(
    _$LoadCoverLettersImpl value,
    $Res Function(_$LoadCoverLettersImpl) then,
  ) = __$$LoadCoverLettersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadCoverLettersImplCopyWithImpl<$Res>
    extends _$CoverLetterEventCopyWithImpl<$Res, _$LoadCoverLettersImpl>
    implements _$$LoadCoverLettersImplCopyWith<$Res> {
  __$$LoadCoverLettersImplCopyWithImpl(
    _$LoadCoverLettersImpl _value,
    $Res Function(_$LoadCoverLettersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadCoverLettersImpl implements LoadCoverLetters {
  const _$LoadCoverLettersImpl();

  @override
  String toString() {
    return 'CoverLetterEvent.loadCoverLetters()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadCoverLettersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )
    generateCoverLetter,
    required TResult Function() loadCoverLetters,
    required TResult Function(String id) loadCoverLetter,
  }) {
    return loadCoverLetters();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult? Function()? loadCoverLetters,
    TResult? Function(String id)? loadCoverLetter,
  }) {
    return loadCoverLetters?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult Function()? loadCoverLetters,
    TResult Function(String id)? loadCoverLetter,
    required TResult orElse(),
  }) {
    if (loadCoverLetters != null) {
      return loadCoverLetters();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateCoverLetter value) generateCoverLetter,
    required TResult Function(LoadCoverLetters value) loadCoverLetters,
    required TResult Function(LoadCoverLetter value) loadCoverLetter,
  }) {
    return loadCoverLetters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult? Function(LoadCoverLetters value)? loadCoverLetters,
    TResult? Function(LoadCoverLetter value)? loadCoverLetter,
  }) {
    return loadCoverLetters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult Function(LoadCoverLetters value)? loadCoverLetters,
    TResult Function(LoadCoverLetter value)? loadCoverLetter,
    required TResult orElse(),
  }) {
    if (loadCoverLetters != null) {
      return loadCoverLetters(this);
    }
    return orElse();
  }
}

abstract class LoadCoverLetters implements CoverLetterEvent {
  const factory LoadCoverLetters() = _$LoadCoverLettersImpl;
}

/// @nodoc
abstract class _$$LoadCoverLetterImplCopyWith<$Res> {
  factory _$$LoadCoverLetterImplCopyWith(
    _$LoadCoverLetterImpl value,
    $Res Function(_$LoadCoverLetterImpl) then,
  ) = __$$LoadCoverLetterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$LoadCoverLetterImplCopyWithImpl<$Res>
    extends _$CoverLetterEventCopyWithImpl<$Res, _$LoadCoverLetterImpl>
    implements _$$LoadCoverLetterImplCopyWith<$Res> {
  __$$LoadCoverLetterImplCopyWithImpl(
    _$LoadCoverLetterImpl _value,
    $Res Function(_$LoadCoverLetterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$LoadCoverLetterImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadCoverLetterImpl implements LoadCoverLetter {
  const _$LoadCoverLetterImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'CoverLetterEvent.loadCoverLetter(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadCoverLetterImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadCoverLetterImplCopyWith<_$LoadCoverLetterImpl> get copyWith =>
      __$$LoadCoverLetterImplCopyWithImpl<_$LoadCoverLetterImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )
    generateCoverLetter,
    required TResult Function() loadCoverLetters,
    required TResult Function(String id) loadCoverLetter,
  }) {
    return loadCoverLetter(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult? Function()? loadCoverLetters,
    TResult? Function(String id)? loadCoverLetter,
  }) {
    return loadCoverLetter?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String resumeId,
      String jobDescription,
      String? jobId,
      String? tone,
    )?
    generateCoverLetter,
    TResult Function()? loadCoverLetters,
    TResult Function(String id)? loadCoverLetter,
    required TResult orElse(),
  }) {
    if (loadCoverLetter != null) {
      return loadCoverLetter(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GenerateCoverLetter value) generateCoverLetter,
    required TResult Function(LoadCoverLetters value) loadCoverLetters,
    required TResult Function(LoadCoverLetter value) loadCoverLetter,
  }) {
    return loadCoverLetter(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult? Function(LoadCoverLetters value)? loadCoverLetters,
    TResult? Function(LoadCoverLetter value)? loadCoverLetter,
  }) {
    return loadCoverLetter?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GenerateCoverLetter value)? generateCoverLetter,
    TResult Function(LoadCoverLetters value)? loadCoverLetters,
    TResult Function(LoadCoverLetter value)? loadCoverLetter,
    required TResult orElse(),
  }) {
    if (loadCoverLetter != null) {
      return loadCoverLetter(this);
    }
    return orElse();
  }
}

abstract class LoadCoverLetter implements CoverLetterEvent {
  const factory LoadCoverLetter(final String id) = _$LoadCoverLetterImpl;

  String get id;

  /// Create a copy of CoverLetterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadCoverLetterImplCopyWith<_$LoadCoverLetterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
