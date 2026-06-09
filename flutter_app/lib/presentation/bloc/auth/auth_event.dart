import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginSubmitted({
    required String email,
    required String password,
  }) = LoginSubmitted;

  const factory AuthEvent.registerSubmitted({
    required String email,
    required String password,
    required String name,
  }) = RegisterSubmitted;

  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;

  const factory AuthEvent.logoutRequested() = LogoutRequested;
}
