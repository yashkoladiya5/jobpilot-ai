import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Represents the various states of user authentication within the application.
@freezed
class AuthState with _$AuthState {
  const factory AuthState.authInitial() = AuthInitial;

  const factory AuthState.authLoading() = AuthLoading;

  /// The user has successfully authenticated and their profile data is available.
  const factory AuthState.authenticated({required User user}) = Authenticated;

  const factory AuthState.unauthenticated({String? message}) = Unauthenticated;

  const factory AuthState.authError({required String message}) = AuthError;
}
