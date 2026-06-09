import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.authInitial() = AuthInitial;

  const factory AuthState.authLoading() = AuthLoading;

  const factory AuthState.authenticated({required User user}) = Authenticated;

  const factory AuthState.unauthenticated({String? message}) = Unauthenticated;

  const factory AuthState.authError({required String message}) = AuthError;
}
