import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/user.dart';
import 'package:jobpilot_ai/domain/repositories/auth_repository.dart';
import 'package:jobpilot_ai/domain/usecases/auth/login_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/auth/logout_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/auth/register_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_event.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_state.dart';

class FakeAuthRepository implements AuthRepository {
  bool authenticated = false;
  Either<Failure, User>? loginResult;
  Either<Failure, User>? registerResult;
  Either<Failure, Unit>? logoutResult;
  Either<Failure, User>? meResult;

  @override
  Future<Either<Failure, User>> login(String email, String password) async =>
      loginResult ?? Right(User(id: '1', email: email, name: 'Test User'));

  @override
  Future<Either<Failure, User>> register(String email, String password, String name) async =>
      registerResult ?? Right(User(id: '1', email: email, name: name));

  @override
  Future<Either<Failure, Unit>> logout() async => logoutResult ?? const Right(unit);

  @override
  Future<bool> isAuthenticated() async => authenticated;

  Future<Either<Failure, User>> getProfile() async =>
      const Right(User(id: '1', email: 'test@example.com', name: 'Test User'));

  @override
  Future<Either<Failure, User>> getMe() async =>
      meResult ?? const Right(User(id: '1', email: 'me@example.com', name: 'Me'));
}

void main() {
  late FakeAuthRepository repository;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;
  late LogoutUseCase logoutUseCase;
  late AuthBloc authBloc;

  final tUser = User(id: 'user-1', email: 'alex@example.com', name: 'Alex');

  setUp(() {
    repository = FakeAuthRepository();
    loginUseCase = LoginUseCase(repository);
    registerUseCase = RegisterUseCase(repository);
    logoutUseCase = LogoutUseCase(repository);
    authBloc = AuthBloc(loginUseCase, registerUseCase, logoutUseCase);
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state is AuthInitial', () {
    expect(authBloc.state, equals(const AuthInitial()));
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Authenticated] when LoginSubmitted succeeds',
    build: () {
      repository.loginResult = Right(tUser);
      return authBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitted(email: 'alex@example.com', password: 'password123')),
    expect: () => [
      const AuthLoading(),
      Authenticated(user: tUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthError] when LoginSubmitted fails',
    build: () {
      repository.loginResult = const Left(Failure.authFailure(message: 'Invalid credentials'));
      return authBloc;
    },
    act: (bloc) => bloc.add(const LoginSubmitted(email: 'alex@example.com', password: 'wrong')),
    expect: () => [
      const AuthLoading(),
      const AuthError(message: 'Invalid credentials'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Authenticated] when RegisterSubmitted succeeds',
    build: () {
      repository.registerResult = Right(tUser);
      return authBloc;
    },
    act: (bloc) => bloc.add(const RegisterSubmitted(
      email: 'alex@example.com',
      password: 'password123',
      name: 'Alex',
    )),
    expect: () => [
      const AuthLoading(),
      Authenticated(user: tUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Unauthenticated] when LogoutRequested succeeds',
    build: () {
      repository.logoutResult = const Right(unit);
      return authBloc;
    },
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => [
      const AuthLoading(),
      const Unauthenticated(),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Authenticated] when CheckAuthStatus is authenticated',
    build: () {
      repository.authenticated = true;
      repository.meResult = Right(tUser);
      return authBloc;
    },
    act: (bloc) => bloc.add(const CheckAuthStatus()),
    expect: () => [
      const AuthLoading(),
      Authenticated(user: tUser),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Unauthenticated] when CheckAuthStatus is not authenticated',
    build: () {
      repository.authenticated = false;
      return authBloc;
    },
    act: (bloc) => bloc.add(const CheckAuthStatus()),
    expect: () => [
      const AuthLoading(),
      const Unauthenticated(),
    ],
  );
}
