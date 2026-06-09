import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/usecases/auth/login_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/auth/logout_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/auth/register_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_event.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
  ) : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result =
        await _registerUseCase(event.email, event.password, event.name);
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final isAuth = await _loginUseCase.repository.isAuthenticated();
      if (isAuth) {
        final result = await _loginUseCase.repository.getMe();
        result.fold(
          (failure) => emit(const Unauthenticated()),
          (user) => emit(Authenticated(user: user)),
        );
      } else {
        emit(const Unauthenticated());
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(const Unauthenticated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      serverFailure: (message, code) => message,
      networkFailure: (message, code) => message,
      authFailure: (message, code) => message,
      validationFailure: (message, code) => message,
      cacheFailure: (message, code) => message,
      notFoundFailure: (message, code) => message,
    );
  }
}
