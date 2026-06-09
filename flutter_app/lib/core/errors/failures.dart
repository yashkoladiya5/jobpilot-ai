import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.serverFailure({
    required String message,
    int? code,
  }) = ServerFailure;

  const factory Failure.networkFailure({
    required String message,
    int? code,
  }) = NetworkFailure;

  const factory Failure.authFailure({
    required String message,
    int? code,
  }) = AuthFailure;

  const factory Failure.validationFailure({
    required String message,
    int? code,
  }) = ValidationFailure;

  const factory Failure.cacheFailure({
    required String message,
    int? code,
  }) = CacheFailure;

  const factory Failure.notFoundFailure({
    required String message,
    int? code,
  }) = NotFoundFailure;
}
