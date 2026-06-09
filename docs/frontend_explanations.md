# JobPilot AI — Frontend Explanations

> **Purpose:** Deep-dive into the Flutter architecture, patterns, and rationale.  
> **Target Audience:** Flutter developer (3+ yrs) learning full-stack/backend patterns.  
> **Last Updated:** June 2026

---

## Table of Contents

1. [Clean Architecture Folder Structure](#1-clean-architecture-folder-structure)
2. [BLoC Lifecycle](#2-bloc-lifecycle)
3. [Dependency Injection with Injectable](#3-dependency-injection-with-injectable)
4. [Go Router](#4-go-router)
5. [Dio and the Interceptor Pattern](#5-dio-and-the-interceptor-pattern)
6. [Freezed: Code Generation and Union Types](#6-freezed-code-generation-and-union-types)
7. [Network Layer](#7-network-layer)
8. [Theme System](#8-theme-system)

---

## 1. Clean Architecture Folder Structure

### Physical Structure

```
lib/
├── core/                          # Shared infrastructure
│   ├── constants/
│   │   ├── api_constants.dart      # Base URL, endpoints, timeouts
│   │   └── app_constants.dart      # App-wide constants (padding, sizes)
│   │
│   ├── error/
│   │   ├── failures.dart           # Failure sealed class hierarchy
│   │   └── exceptions.dart         # Exception classes for data layer
│   │
│   ├── network/
│   │   ├── dio_client.dart         # Dio instance creation, interceptors
│   │   ├── auth_interceptor.dart   # Token injection + refresh
│   │   ├── error_interceptor.dart  # Error mapping
│   │   └── network_info.dart       # Connectivity check
│   │
│   ├── theme/
│   │   ├── app_theme.dart          # Material 3 theme definitions
│   │   ├── app_colors.dart         # Color scheme tokens
│   │   └── app_typography.dart     # Text styles
│   │
│   └── utils/
│       ├── extensions.dart         # Dart extension methods
│       └── validators.dart         # Form validation logic
│
├── data/                           # Data Layer
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   ├── job_remote_datasource.dart
│   │   └── resume_remote_datasource.dart
│   │
│   ├── models/
│   │   ├── auth_models.dart        # AuthRequest, AuthResponse (Freezed)
│   │   ├── job_models.dart         # JobModel (Freezed, JSON serialization)
│   │   └── resume_models.dart      # ResumeModel
│   │
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── job_repository_impl.dart
│       └── resume_repository_impl.dart
│
├── domain/                         # Domain Layer (Pure Dart)
│   ├── entities/
│   │   ├── user.dart               # User entity
│   │   ├── job.dart                # Job entity
│   │   └── resume.dart             # Resume entity
│   │
│   ├── repositories/               # Abstract contracts
│   │   ├── auth_repository.dart
│   │   ├── job_repository.dart
│   │   └── resume_repository.dart
│   │
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   ├── register_usecase.dart
│       │   └── logout_usecase.dart
│       ├── job/
│       │   ├── get_jobs_usecase.dart
│       │   ├── create_job_usecase.dart
│       │   ├── update_job_usecase.dart
│       │   └── delete_job_usecase.dart
│       └── resume/
│           ├── upload_resume_usecase.dart
│           └── get_resumes_usecase.dart
│
├── presentation/                   # Presentation Layer
│   ├── auth/
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── pages/
│   │   │   ├── login_page.dart
│   │   │   └── register_page.dart
│   │   └── widgets/
│   │       ├── auth_text_field.dart
│   │       └── social_login_button.dart
│   │
│   ├── dashboard/
│   │   ├── bloc/
│   │   ├── pages/
│   │   │   └── dashboard_page.dart
│   │   └── widgets/
│   │       ├── stat_card.dart
│   │       └── recent_applications_list.dart
│   │
│   ├── jobs/
│   │   ├── bloc/
│   │   ├── pages/
│   │   │   ├── jobs_page.dart
│   │   │   └── job_detail_page.dart
│   │   └── widgets/
│   │       ├── job_card.dart
│   │       └── job_status_chip.dart
│   │
│   ├── resumes/
│   │   ├── bloc/
│   │   ├── pages/
│   │   │   └── resumes_page.dart
│   │   └── widgets/
│   │       └── resume_tile.dart
│   │
│   └── splash/
│       └── pages/
│           └── splash_page.dart
│
├── router/
│   ├── app_router.dart             # GoRouter configuration
│   └── route_names.dart            # Named route constants
│
└── main.dart                       # Entry point: DI setup, app bootstrap
```

### Why This Structure?

**Feature-first within layers:** The top-level split is by layer (core, data, domain, presentation). Within each layer, files are grouped by feature (auth, jobs, resumes, dashboard). This gives you two axes of organization — architectural role and business domain. You can find all files related to "jobs" across all layers, or all files related to "data" across all features.

**Why `core/` exists:** Shared infrastructure that doesn't belong to any feature or layer. The Dio client, theme definitions, constants, and utilities are used across features. Isolating them prevents circular dependencies and makes them testable independently.

**Why `domain/repositories/` are abstract:** The domain layer defines interfaces (`abstract class JobRepository`) but never implements them. This is the Dependency Inversion Principle: high-level modules (domain) should not depend on low-level modules (data). Both should depend on abstractions. The `data/repositories/` folder contains the concrete implementations.

**Why `presentation/pages/` and `presentation/widgets/` are separate:** Pages are full screens (context-aware, navigate, use BLoC). Widgets are reusable components (no navigation logic, receive data via constructors). This separation ensures widgets are testable without routing setup.

### Data Flow Through Layers

```
USER TAPS "SAVE" ON CREATE JOB FORM
         │
         ▼
┌─────────────────┐
│   UI (Widget)   │  Presentation Layer
│   CreateJobPage │  • Renders form, validates input
│                 │  • Dispatches CreateJobEvent on submit
└────────┬────────┘
         │ CreateJobEvent(company, role, status)
         ▼
┌─────────────────┐
│  BLoC (JobBloc) │  Presentation Layer
│                 │  • Receives event
│                 │  • Calls CreateJobUsecase
│                 │  • Emits JobLoading → JobCreated | JobError
└────────┬────────┘
         │ Future<Either<Failure, Job>>
         ▼
┌─────────────────┐
│ UseCase          │  Domain Layer
│ CreateJobUsecase │  • Pure Dart, no Flutter deps
│ .call(params)   │  • Calls abstract JobRepository
│                 │  • Returns Either<Failure, Job>
└────────┬────────┘
         │ Future<Either<Failure, Job>>
         ▼
┌─────────────────┐
│ Repository      │  Data Layer
│ JobRepositoryImpl│  • Implements abstract JobRepository
│                 │  • Calls JobRemoteDataSource
│                 │  • Maps Model ↔ Entity
│                 │  • Converts exceptions to Failures
└────────┬────────┘
         │ Future<List<JobModel>>
         ▼
┌─────────────────┐
│ DataSource      │  Data Layer
│ JobRemoteDS     │  • Makes HTTP call via Dio
│ .createJob()    │  • Returns JobModel from JSON
└────────┬────────┘
         │ POST /api/jobs (HTTP)
         ▼
┌─────────────────┐
│   Express API    │  Backend
└─────────────────┘
```

### Why Three Layers Instead of Two?

Some Flutter architectures use two layers (data + UI). Adding a domain layer (use cases + entities + abstract repositories) provides:
1. **Testing isolation:** Use cases are pure Dart — instant to test, no widget tree needed
2. **Business logic centralization:** Complex rules live in use cases, not scattered across BLoCs
3. **Independence from frameworks:** Domain has zero imports from Flutter, Dio, or any package
4. **Feature coordination:** When a feature needs multiple data sources, the use case orchestrates them

The cost is more files. Each feature has roughly: 1 entity, 1 repository interface, 2-4 use cases, 1 data source, 1 model, 1 repository implementation, 1 BLoC, 1 event file, 1 state file, 1-2 pages, 2-4 widgets. That's 15-20 files per feature instead of 3-5 in a simpler architecture. For this project's scale (auth, jobs, resumes, dashboard, future AI), the maintainability benefits justify the file count.

---

## 2. BLoC Lifecycle

### The Full Cycle

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      BLoC LIFECYCLE (Login Example)                      │
│                                                                          │
│  1. WIDGET BUILDS                                                        │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  LoginPage builds with BlocProvider<AuthBloc>                    │ │
│     │  → GetIt resolves AuthBloc with all dependencies                │ │
│     └──────────────────────────────────────────────────────────────────┘ │
│                                   │                                       │
│                                   ▼                                       │
│  2. USER INTERACTION                                                     │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  User taps "Login" after filling email + password                │ │
│     │  context.read<AuthBloc>().add(LoginEvent(email, password))       │ │
│     └──────────────────────────────────────────────────────────────────┘ │
│                                   │                                       │
│                                   ▼                                       │
│  3. EVENT DISPATCHED                                                     │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  AuthBloc.on<LoginEvent>((event, emit) async {                  │ │
│     │    // Event handler is called by BLoC framework                  │ │
│     │  });                                                              │ │
│     └──────────────────────────────────────────────────────────────────┘ │
│                                   │                                       │
│                                   ▼                                       │
│  4. EMIT LOADING STATE                                                    │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  emit(AuthLoading())                                             │ │
│     │  → UI rebuilds: LoginPage shows CircularProgressIndicator       │ │
│     │  → Buttons become disabled                                       │ │
│     └──────────────────────────────────────────────────────────────────┘ │
│                                   │                                       │
│                                   ▼                                       │
│  5. CALL USE CASE                                                        │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  final result = await loginUsecase.call(LoginParams(             │ │
│     │    email: event.email,                                           │ │
│     │    password: event.password,                                     │ │
│     │  ));                                                              │ │
│     │  // result is Either<Failure, User>                              │ │
│     └──────────────────────────────────────────────────────────────────┘ │
│                                   │                                       │
│                  ┌────────────────┼────────────────┐                      │
│                  ▼                ▼                ▼                      │
│          ┌────────────┐  ┌──────────────┐  ┌──────────────┐              │
│          │ SUCCESS    │  │ FAILURE       │  │ EXCEPTION    │              │
│          └──────┬─────┘  └──────┬───────┘  └──────┬───────┘              │
│                 ▼               ▼                  ▼                      │
│  6. EMIT NEW STATE                                                        │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  result.fold(                                                    │ │
│     │    (failure) => emit(AuthError(failure.message)),                │ │
│     │    (user) => emit(AuthAuthenticated(user)),                      │ │
│     │  );                                                               │ │
│     └──────────────────────────────────────────────────────────────────┘ │
│                                   │                                       │
│                                   ▼                                       │
│  7. UI REBUILDS                                                           │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  BlocBuilder<AuthBloc, AuthState>(                               │ │
│     │    builder: (context, state) {                                   │ │
│     │      return state.when(                                          │ │
│     │        initial: () => LoginForm(),                               │ │
│     │        loading: () => LoadingIndicator(),                        │ │
│     │        authenticated: (user) => Navigator redirect to dashboard, │ │
│     │        error: (message) => ErrorBanner(message),                 │ │
│     │      );                                                           │ │
│     │    },                                                              │ │
│     │  )                                                                 │ │
│     └──────────────────────────────────────────────────────────────────┘ │
│                                   │                                       │
│                                   ▼                                       │
│  8. DISPOSE                                                               │
│     ┌──────────────────────────────────────────────────────────────────┐ │
│     │  When user navigates away from Auth feature:                    │ │
│     │  → BlocProvider.dispose() closes AuthBloc                       │ │
│     │  → AuthBloc.close() closes all stream controllers              │ │
│     │  → Memory is freed                                               │ │
│     └──────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```

### BlocProvider Scoping

BLoCs are provided at different levels of the widget tree depending on their scope:

```dart
// App-level (exists for entire app lifetime)
MaterialApp(
  builder: (context, child) => MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
      BlocProvider<ThemeBloc>(create: (_) => getIt<ThemeBloc>()),
    ],
    child: child,
  ),
);

// Feature-level (exists only when user is on this feature)
// GoRouter's ShellRoute or page builder provides it
GoRoute(
  path: '/jobs',
  builder: (context, state) => BlocProvider(
    create: (_) => getIt<JobBloc>(),
    child: const JobsPage(),
  ),
);
```

**Why this matters:** Scoping BLoCs to features means they're created on navigation and disposed on exit. Memory is proportional to what the user is currently doing, not to the total number of features. This also ensures stale data is cleared — when you navigate away from Jobs and come back, the BLoC re-fetches fresh data.

### BlocBuilder vs BlocListener vs BlocConsumer

```dart
// BlocBuilder: Rebuilds UI on every state change
// Use for: rendering state-dependent content
BlocBuilder<JobBloc, JobState>(
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (jobs) => JobListView(jobs: jobs),
      error: (message) => ErrorWidget(message: message),
    );
  },
);

// BlocListener: Performs side effects on state change (once per state)
// Use for: navigation, snackbars, dialogs
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.whenOrNull(
      authenticated: (_) => context.go('/dashboard'),
      error: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      ),
    );
  },
  child: LoginForm(),
);

// BlocConsumer: Combines builder + listener
// Use for: when you need both in the same widget
BlocConsumer<JobBloc, JobState>(
  listener: (context, state) {
    state.whenOrNull(
      created: (_) => Navigator.pop(context),
      error: (msg) => ScaffoldMessenger.of(context).showSnackBar(...),
    );
  },
  builder: (context, state) {
    return state.when(
      loading: () => const LoadingOverlay(),
      /* ... */
    );
  },
);
```

### The Three-File BLoC Pattern

Each BLoC feature generates three files. This isn't ceremony — it's separation of concerns:

**`auth_event.dart`** — Defines what can happen:
```dart
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = LoginEvent;
  const factory AuthEvent.register({
    required String name,
    required String email,
    required String password,
  }) = RegisterEvent;
  const factory AuthEvent.logout() = LogoutEvent;
}
```

**`auth_state.dart`** — Defines what can be displayed:
```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.error(String message) = AuthError;
}
```

**`auth_bloc.dart`** — Defines the transformation (events → states):
```dart
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
  }) : super(const AuthState.initial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await loginUsecase.call(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }
}
```

**Why separate files?** Events change when new user actions are added. States change when new UI variations are needed. The BLoC changes when orchestration logic changes. With separate files, a commit that adds a "reset password" event touches only `auth_event.dart` and `auth_bloc.dart` — the state file is untouched. Code reviews are smaller, merges are cleaner, and testing is more focused.

---

## 3. Dependency Injection with Injectable

### Why Dependency Injection Matters in Flutter

Without DI, a typical BLoC might look like:
```dart
class JobBloc extends Bloc<JobEvent, JobState> {
  final jobRepository = JobRepositoryImpl(
    remoteDataSource: JobRemoteDataSource(
      dio: Dio(BaseOptions(baseUrl: 'https://api.example.com')),
    ),
  );
  // ...
}
```

This BLoC is untestable — you cannot test it without making real API calls. It's also brittle — changing the Dio configuration means editing every BLoC that uses it. DI solves this by having dependencies provided (injected) from the outside.

### Injectable + GetIt

`injectable` is a code generator that reads annotations and generates `GetIt` registration code. It removes the manual wiring burden while keeping compile-time safety.

**How it works:**

1. Annotate classes with `@injectable`:
```dart
@injectable
class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc({required GetJobsUsecase getJobs, required CreateJobUsecase createJob});
}

@injectable
class GetJobsUsecase {
  GetJobsUsecase({required JobRepository repository});
}

@injectable
class JobRepositoryImpl implements JobRepository {
  JobRepositoryImpl({required JobRemoteDataSource remoteDataSource});
}
```

2. Configure modules for third-party classes:
```dart
@module
abstract class AppModule {
  @singleton
  Dio get dio => Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  @Named('secureStorage')
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
```

3. Run the code generator:
```bash
flutter pub run build_runner build
```

4. Generated `injectable.config.dart`:
```dart
// AUTO-GENERATED — do not edit
final getIt = GetIt.instance;

@pragma('vm:prefer-initialize')
Future<void> configureDependencies({String? environment}) async {
  final gh = GetItHelper(getIt, environment);

  gh.singleton<Dio>(() => Dio(...));
  gh.singleton<FlutterSecureStorage>(() => const FlutterSecureStorage(), instanceName: 'secureStorage');
  gh.factory<JobRemoteDataSource>(() => JobRemoteDataSource(getIt<Dio>()));
  gh.factory<JobRepositoryImpl>(() => JobRepositoryImpl(getIt<JobRemoteDataSource>()));
  gh.factory<JobRepository>(() => getIt<JobRepositoryImpl>()); // Register as interface
  gh.factory<GetJobsUsecase>(() => GetJobsUsecase(getIt<JobRepository>()));
  gh.factory<JobBloc>(() => JobBloc(getIt<GetJobsUsecase>(), getIt<CreateJobUsecase>()));
}
```

5. In `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const JobPilotApp());
}
```

### Registration Scopes

| Scope | Annotation | Behavior | Use Case |
|-------|-----------|----------|----------|
| Singleton | `@singleton` | One instance for app lifetime | Dio client, secure storage |
| LazySingleton | `@lazySingleton` | Created on first access, then reused | Prisma-like (one-time init) |
| Factory | `@factory` | New instance every time | Use cases (stateless), BLoCs (scoped) |
| PreResolve | `@preResolve` | Created eagerly at startup | Config loaders |

**Why factories for BLoCs:** Each BLoC is scoped to its feature route. Creating a new instance on navigation ensures fresh state. If BLoCs were singletons, navigating away and back would show stale data — you'd need manual reset logic.

### Testing with Injectable

```dart
// In test setup
void main() {
  late MockJobRepository mockRepository;
  late GetJobsUsecase usecase;

  setUp(() {
    mockRepository = MockJobRepository();
    usecase = GetJobsUsecase(repository: mockRepository);
    // No GetIt needed — manual DI for tests
  });

  test('should return jobs', () async {
    when(() => mockRepository.getJobs()).thenAnswer((_) async => Right([testJob]));
    final result = await usecase();
    expect(result, Right([testJob]));
  });
}
```

For BLoC testing, you provide mock dependencies directly — no GetIt involved:
```dart
blocTest<JobBloc, JobState>(
  'emits [Loading, Loaded] when jobs are fetched',
  build: () => JobBloc(
    getJobs: MockGetJobsUsecase(), // Pass mock directly
    createJob: MockCreateJobUsecase(),
  ),
  act: (bloc) => bloc.add(const LoadJobsEvent()),
  expect: () => [JobLoading(), JobsLoaded(testJobs)],
);
```

---

## 4. Go Router

### Why Declarative Routing

Imperative routing (`Navigator.pushNamed(context, '/jobs')`) scatters navigation logic across widgets. A "go to login if unauthorized" check must be repeated everywhere. Go Router solves this with a declarative approach: you define all routes, redirects, and guards in one place.

### Router Configuration

```dart
// router/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/splash',
  
  // Global redirect guard — runs on every navigation
  redirect: (context, state) {
    final authBloc = context.read<AuthBloc>();
    final isLoggedIn = authBloc.state is AuthAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    final isSplash = state.matchedLocation == '/splash';

    // Allow splash screen for everyone
    if (isSplash) return null;

    // Not logged in → redirect to login (unless already there)
    if (!isLoggedIn && !isAuthRoute) return '/auth/login';

    // Logged in → redirect to dashboard (no need to see auth screens)
    if (isLoggedIn && isAuthRoute) return '/dashboard';

    return null; // No redirect
  },

  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),

    GoRoute(
      path: '/auth',
      routes: [
        GoRoute(
          path: 'login',
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: 'register',
          builder: (_, __) => const RegisterPage(),
        ),
      ],
    ),

    // ShellRoute wraps child routes in a scaffold with bottom navigation
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (_, __) => const NoTransitionPage(
            child: DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/jobs',
          routes: [
            GoRoute(
              path: ':id', // /jobs/:id — type-safe parameter
              builder: (_, state) => JobDetailPage(
                jobId: state.pathParameters['id']!,
              ),
            ),
          ],
          pageBuilder: (_, __) => const NoTransitionPage(
            child: JobsPage(),
          ),
        ),
        GoRoute(
          path: '/resumes',
          pageBuilder: (_, __) => const NoTransitionPage(
            child: ResumesPage(),
          ),
        ),
      ],
    ),
  ],

  // Error page for unknown routes
  errorBuilder: (_, __) => const NotFoundPage(),
);
```

### Redirect Guard Deep Dive

The `redirect` callback runs on every navigation attempt. It checks the auth state and redirects accordingly. The key design considerations:

1. **Always returns a value or null:** Return `null` means "proceed with the requested navigation". Return a string means "redirect to this path instead".

2. **Prevents redirect loops:** The guard must check if the user is already on the target route. Without `isAuthRoute` check, an unauthenticated user going to `/dashboard` would redirect to `/auth/login`, which would redirect to `/dashboard` (because user is now on auth route and logged in? No — the redirect guard must carefully avoid infinite loops).

3. **Auth state is read from context:** `context.read<AuthBloc>()` must be accessible. This is why the `MaterialApp.router` is wrapped in `BlocProvider`.

### Shell Routes for Bottom Navigation

```dart
ShellRoute(
  builder: (_, __, child) => AppShell(child: child),
  routes: [
    GoRoute(path: '/dashboard', ...),
    GoRoute(path: '/jobs', ...),
    GoRoute(path: '/resumes', ...),
  ],
);
```

`ShellRoute` renders a parent widget (`AppShell` with bottom navigation) that persists across child route changes. When the user switches from Dashboard to Jobs, only the child content rebuilds — the bottom nav, app bar, and scaffold stay intact. This is the correct pattern for bottom navigation and avoids the common mistake of rebuilding the entire page (and losing scroll position) on tab switch.

### Deep Linking

Go Router supports deep linking on both mobile (Firebase Dynamic Links, Universal Links) and web (URL-based routing). If a user receives a link to `https://jobpilot.app/jobs/abc-123`, Go Router's redirect guard runs first:
1. Check auth state → if not logged in, redirect to `/auth/login`
2. After login, the redirect guard returns `null` for the original deep link
3. User lands on `JobDetailPage(jobId: 'abc-123')`

This works because Go Router remembers the intended destination before redirect. The `redirect` callback must not block this — it should only redirect for auth, not for parameters.

---

## 5. Dio and the Interceptor Pattern

### Why Dio Over http Package

The standard Dart `http` package is fine for simple requests but lacks features essential for production apps:

| Feature | Dio | http |
|---------|-----|------|
| Request/response interceptors | ✅ Built-in | ❌ Manual wrapper |
| Auth token injection | ✅ Interceptor | ❌ Manual per request |
| Automatic token refresh | ✅ Interceptor chain | ❌ Manual |
| Request cancellation | ✅ CancelToken | ❌ |
| Upload progress | ✅ onSendProgress | ❌ |
| Download progress | ✅ onReceiveProgress | ❌ |
| FormData/multipart | ✅ Built-in | ❌ Manual |
| Retry on failure | ✅ RetryInterceptor | ❌ Manual |
| Timeout per request | ✅ Fine-grained | ❌ Global only |

### Interceptor Architecture

Interceptors form a chain. Each interceptor can process the request before it's sent, process the response after it arrives, or handle errors. The order matters:

```
REQUEST DIRECTION:
AuthInterceptor → LogInterceptor → ErrorInterceptor → HTTP call

RESPONSE DIRECTION:
HTTP response → ErrorInterceptor → LogInterceptor → AuthInterceptor → DataSource
```

### AuthInterceptor

```dart
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Dio dio; // Separate Dio instance for refresh calls

  AuthInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth header for login/register/refresh endpoints
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }

    final token = await secureStorage.read(key: 'accessToken');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt to refresh token
      try {
        final refreshToken = await secureStorage.read(key: 'refreshToken');
        if (refreshToken == null) {
          return handler.next(err); // No refresh token, fail
        }

        // Call refresh endpoint (using a separate Dio to avoid interceptor loop)
        final response = await dio.post(
          '/api/auth/refresh',
          data: { 'refreshToken': refreshToken },
        );

        // Store new tokens
        await secureStorage.write(key: 'accessToken', value: response.data['data']['accessToken']);
        await secureStorage.write(key: 'refreshToken', value: response.data['data']['refreshToken']);

        // Retry the original request with new token
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer ${response.data['data']['accessToken']}';
        final retryResponse = await dio.fetch(retryOptions);
        return handler.resolve(retryResponse);
      } catch (refreshError) {
        // Refresh failed — user must log in again
        await secureStorage.deleteAll();
        // Emit logout event (via event bus or bloc access)
        handler.next(err);
      }
    }
    handler.next(err);
  }
}
```

Key design decisions:
- **Separate Dio instance for refresh:** Using the same Dio client would trigger the interceptor again, causing infinite loops.
- **Skip auth header for auth endpoints:** `/auth/login` doesn't need a token. This prevents wasted work and avoids sending an expired token on the refresh call.
- **Retry with resolved response:** `handler.resolve()` completes the original request with the new successful response — the caller never knows a refresh happened.
- **Clear storage on refresh failure:** If the refresh token is also invalid/expired, clear all stored tokens and let the user re-authenticate.

### ErrorInterceptor

```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Failure failure;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        failure = NetworkFailure('Connection timed out. Please check your internet.');
        break;
      case DioExceptionType.connectionError:
        failure = NetworkFailure('No internet connection.');
        break;
      case DioExceptionType.badResponse:
        failure = _mapStatusCode(err.response!);
        break;
      case DioExceptionType.cancel:
        // Request was cancelled (user navigated away) — don't propagate
        return handler.reject(err);
      default:
        failure = ServerFailure('An unexpected error occurred.');
    }

    // Attach failure to error for downstream handling
    err.failure = failure;
    handler.next(err);
  }

  Failure _mapStatusCode(Response response) {
    final message = response.data?['message'] ?? 'Unknown error';
    switch (response.statusCode) {
      case 400: return ValidationFailure(message);
      case 401: return AuthFailure(message);
      case 403: return AuthFailure('You do not have permission.');
      case 404: return NotFoundFailure(message);
      case 409: return ConflictFailure(message);
      case 422: return ValidationFailure(message);
      case 500: return ServerFailure('Server error. Please try again later.');
      default: return ServerFailure(message);
    }
  }
}
```

The ErrorInterceptor maps HTTP errors to domain `Failure` objects. Instead of the BLoC receiving a `DioException` (a framework type it shouldn't know about), it receives domain-specific failures like `NetworkFailure`, `AuthFailure`, or `ValidationFailure`. This keeps the BLoC clean and framework-independent.

### Dio Client Setup

```dart
// core/network/dio_client.dart
Dio createDioClient({
  required FlutterSecureStorage secureStorage,
}) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Second Dio instance for token refresh (no auth interceptor)
  final refreshDio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(secureStorage: secureStorage, dio: refreshDio),
    LogInterceptor(requestBody: true, responseBody: true),
    ErrorInterceptor(),
  ]);

  return dio;
}
```

### Request Cancellation

```dart
// In a BLoC or UseCase
class GetJobsUsecase {
  CancelToken? _cancelToken;

  Future<Either<Failure, List<Job>>> call() async {
    _cancelToken?.cancel('New request initiated');
    _cancelToken = CancelToken();

    try {
      final jobs = await repository.getJobs(cancelToken: _cancelToken);
      return Right(jobs);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        // Request was cancelled, don't propagate
        return Left(CancelledFailure());
      }
      rethrow;
    }
  }

  void cancel() => _cancelToken?.cancel('Disposed');
}
```

When a user navigates away from the Jobs page, the BLoC is disposed and cancels any in-flight requests. This prevents a race condition where a response arrives after the BLoC is disposed, triggering `emit()` on a closed stream (which throws in debug mode).

---

## 6. Freezed: Code Generation and Union Types

### Why Freezed Exists

Dart classes need `==`, `hashCode`, `toString`, `copyWith`, and often `toJson`/`fromJson`. Writing these manually is:
- **Error-prone:** Forgetting to include a field in `copyWith` causes silent bugs
- **Verbose:** A 5-field class requires ~50 lines of boilerplate
- **Maintenance burden:** Adding a field means updating 6 methods

Freezed generates all of this from a single `@freezed` annotation.

### Basic Usage

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

This generates:
- `==` operator comparing all fields
- `hashCode` based on all fields
- `toString()` returning `User(id: abc, name: Yash, email: y@email.com, photoUrl: null)`
- `copyWith(id: newId, name: newName)` — returns new User with only specified fields changed
- `fromJson`/`toJson` for JSON serialization
- `_User` private implementation class

### Union Types for BLoC States

The most powerful Freezed feature for this project is **union types** — sealed class hierarchies that model mutually exclusive states:

```dart
@freezed
sealed class JobState with _$JobState {
  const factory JobState.initial() = JobInitial;
  const factory JobState.loading() = JobLoading;
  const factory JobState.loaded({
    required List<Job> jobs,
    @Default(false) bool hasReachedEnd,
  }) = JobsLoaded;
  const factory JobState.error(String message) = JobError;
}
```

Each variant (`JobInitial`, `JobLoading`, `JobsLoaded`, `JobError`) is a separate class that extends `JobState`. The sealed modifier (Dart 3) ensures the compiler knows all possible subtypes.

### Pattern Matching

```dart
// Exhaustive — must handle every variant (compile error if not)
state.when(
  initial: () => const SizedBox.shrink(),
  loading: () => const LoadingIndicator(),
  loaded: (jobs, hasReachedEnd) => JobListView(
    jobs: jobs,
    hasReachedEnd: hasReachedEnd,
  ),
  error: (message) => ErrorWidget(message: message),
);

// Partial — only handle specific variants
state.maybeWhen(
  loading: () => const LoadingOverlay(),
  orElse: () => const SizedBox.shrink(),
);

// Map — returns a value from each variant
final uiState = state.map(
  initial: (_) => UIState.idle,
  loading: (_) => UIState.loading,
  loaded: (_) => UIState.data,
  error: (_) => UIState.error,
);
```

### Event Union Types

```dart
@freezed
sealed class JobEvent with _$JobEvent {
  const factory JobEvent.loadJobs({String? statusFilter}) = LoadJobsEvent;
  const factory JobEvent.loadMore() = LoadMoreEvent;
  const factory JobEvent.createJob({
    required String company,
    required String role,
    required String status,
  }) = CreateJobEvent;
  const factory JobEvent.updateJob({
    required String id,
    required String? status,
    required String? notes,
  }) = UpdateJobEvent;
  const factory JobEvent.deleteJob(String id) = DeleteJobEvent;
}
```

In the BLoC:
```dart
on<JobEvent>((event, emit) {
  event.when(
    loadJobs: (filter) => _onLoadJobs(filter, emit),
    loadMore: (_) => _onLoadMore(emit),
    createJob: (company, role, status) => _onCreateJob(company, role, status, emit),
    updateJob: (id, status, notes) => _onUpdateJob(id, status, notes, emit),
    deleteJob: (id) => _onDeleteJob(id, emit),
  );
});
```

### JSON Serialization

```dart
@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required String id,
    required String company,
    required String role,
    @Default('saved') String status,
    required DateTime appliedDate,
    String? notes,
    String? resumeId,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);
}

// Usage in DataSource
final response = await dio.get('/api/jobs');
return (response.data['data'] as List)
    .map((json) => JobModel.fromJson(json))
    .toList();
```

Freezed integrates with `json_serializable` via the `@JsonSerializable` configuration in `build.yaml`:
```yaml
# build.yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: snake  # Automatically maps JSON snake_case to Dart camelCase
          explicit_to_json: true
```

This means the API returns `applied_date` (snake_case) and Freezed maps it to `appliedDate` (camelCase) automatically.

### Performance Considerations

Freezed-generated `copyWith` creates a new object with the changed fields — it doesn't mutate the original. For a `Job` with 7 fields, this is a single object allocation (negligible cost). The `==` operator compares all fields, which is O(n) where n is field count — for data classes with <20 fields, this is microseconds.

The real performance win: **widgets only rebuild when state actually changes**. With mutable state, two `AuthAuthenticated` instances might have different object references even if the data is the same, triggering unnecessary rebuilds. Freezed's value-based equality ensures `BlocBuilder` only rebuilds when meaningful data changes.

---

## 7. Network Layer

### Architecture Overview

```
┌──────────────────┐
│   Data Source     │  Handles HTTP communication, returns Models
│   (RemoteDS)      │
└────────┬─────────┘
         │ Raw Dart objects (Model)
         ▼
┌──────────────────┐
│  Repository Impl  │  Coordinates data sources, maps Model ↔ Entity
│                   │  Handles errors, caching logic
└────────┬─────────┘
         │ Domain objects (Entity)
         ▼
┌──────────────────┐
│    Use Case       │  Business logic, calls repository
│    (Domain)       │
└────────┬─────────┘
         │ Domain objects (Entity)
         ▼
┌──────────────────┐
│      BLoC         │  State management, calls use case
└──────────────────┘
```

### Why Abstract DataSources

The `DataSource` is the lowest level of the data layer — it makes HTTP calls and returns raw models:

```dart
// data/datasources/job_remote_datasource.dart
@injectable
class JobRemoteDataSource {
  final Dio dio;

  JobRemoteDataSource(this.dio);

  Future<List<JobModel>> getJobs({CancelToken? cancelToken}) async {
    final response = await dio.get(
      '/api/jobs',
      cancelToken: cancelToken,
    );
    return (response.data['data'] as List)
        .map((json) => JobModel.fromJson(json))
        .toList();
  }

  Future<JobModel> createJob(Map<String, dynamic> data) async {
    final response = await dio.post('/api/jobs', data: data);
    return JobModel.fromJson(response.data['data']);
  }
}
```

DataSources are **not abstract** — they're concrete classes that the repository uses. The abstraction happens at the repository interface (in domain). This means:
- DataSources are easily mockable for repository testing
- DataSources don't know about domain entities — they deal in Models
- DataSources don't know about failures — they throw exceptions that the repository catches

### Repository Implementation

```dart
// data/repositories/job_repository_impl.dart
@Injectable(as: JobRepository)
class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  JobRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Job>>> getJobs() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final models = await remoteDataSource.getJobs();
      final jobs = models.map((model) => model.toEntity()).toList();
      return Right(jobs);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } on FormatException {
      return Left(ServerFailure('Invalid response format'));
    }
  }

  @override
  Future<Either<Failure, Job>> createJob(CreateJobParams params) async {
    try {
      final model = await remoteDataSource.createJob(params.toJson());
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    }
  }

  Failure _mapDioExceptionToFailure(DioException e) {
    // Map to appropriate Failure type
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkFailure('Connection timed out');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        if (statusCode == 400) return ValidationFailure(message);
        if (statusCode == 404) return NotFoundFailure(message);
        if (statusCode == 409) return ConflictFailure(message);
        return ServerFailure(message);
      default:
        return ServerFailure('An unexpected error occurred');
    }
  }
}
```

Key patterns:
- `@Injectable(as: JobRepository)` tells Injectable to register this implementation under the interface type.
- `networkInfo.isConnected` check prevents wasting a request when offline.
- `try/catch` catches framework-specific exceptions and maps them to domain `Failure` objects.
- `model.toEntity()` converts from the data-layer Model to the domain-layer Entity.

### Model ↔ Entity Mapping

```dart
// data/models/job_model.dart
@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required String id,
    required String company,
    required String role,
    required String status,
    required DateTime appliedDate,
    String? notes,
    String? resumeId,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

  // Convert to domain entity
  const JobModel._(); // Private constructor for methods
  Job toEntity() => Job(
    id: id,
    company: company,
    role: role,
    status: status,
    appliedDate: appliedDate,
    notes: notes,
    resumeId: resumeId,
  );
}

// domain/entities/job.dart
class Job {
  final String id;
  final String company;
  final String role;
  final String status;
  final DateTime appliedDate;
  final String? notes;
  final String? resumeId;

  const Job({
    required this.id,
    required this.company,
    required this.role,
    required this.status,
    required this.appliedDate,
    this.notes,
    this.resumeId,
  });
}
```

**Why separate Model and Entity?** The Model is coupled to the API (JSON field names, serialization format). The Entity is pure business logic. If the API changes a field name, only the Model changes — the Entity and all code using it stay the same. If we add offline caching with SQLite, the SQLite model might differ from the API model, but both map to the same Entity.

### NetworkInfo

```dart
// core/network/network_info.dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@injectable
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

`NetworkInfo` is abstract to allow testing — in tests, you provide a mock that returns `true` or `false` without checking actual connectivity. The implementation uses the `connectivity_plus` package to check network status.

### Complete Request Flow

```
1. BLoC dispatches LoadJobsEvent
2. JobBloc calls GetJobsUsecase.call()
3. UseCase calls JobRepository.getJobs()
4. Repository checks NetworkInfo.isConnected
   → NO: Return Left(NetworkFailure)
   → YES: Continue
5. Repository calls JobRemoteDataSource.getJobs()
6. DataSource calls dio.get('/api/jobs')
7. AuthInterceptor adds Bearer token
8. Dio makes HTTP request
9. Server responds
10. ErrorInterceptor checks status code
    → Error: Maps to Failure, attaches to Exception
11. DataSource parses JSON → List<JobModel>
12. Repository maps models → entities via .toEntity()
13. Repository wraps in Right(jobs)
14. UseCase returns result to BLoC
15. BLoC emits JobsLoaded(jobs)
16. UI rebuilds via BlocBuilder
```

---

## 8. Theme System

### Material 3 Design

The app uses Material 3 (M3), the latest Material Design version. M3 introduces:
- **Dynamic color:** Extract colors from wallpaper (Android 12+) or use seed colors
- **Color schemes:** Light and dark variants of primary, secondary, tertiary, error, neutral
- **Typography:** Google Fonts (Inter, Roboto, or custom)
- **Shape system:** Small, medium, large component shapes
- **Elevation levels:** 5 levels (0-5) with specific shadows and overlay colors

### Theme Definition

```dart
// core/theme/app_theme.dart
class AppTheme {
  // Light theme
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0), // Primary blue
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      
      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // Bottom navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  // Dark theme
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Dark-specific: surface with overlay for elevated surfaces
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
```

### Theme Switching with BLoC

```dart
// presentation/bloc/theme_bloc.dart
@freezed
sealed class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.toggleTheme() = ToggleThemeEvent;
  const factory ThemeEvent.setTheme(Brightness brightness) = SetThemeEvent;
}

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState.light() = ThemeLight;
  const factory ThemeState.dark() = ThemeDark;
}

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState.light()) {
    on<ToggleThemeEvent>((_, emit) {
      emit(state is ThemeLight ? const ThemeState.dark() : const ThemeState.light());
    });
    on<SetThemeEvent>((event, emit) {
      emit(event.brightness == Brightness.dark
          ? const ThemeState.dark()
          : const ThemeState.light());
    });
  }
}
```

### Theme Application

```dart
class JobPilotApp extends StatelessWidget {
  const JobPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeBloc>(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'JobPilot AI',
            debugShowCheckedModeBanner: false,
            
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeState.when(
              light: () => ThemeMode.light,
              dark: () => ThemeMode.dark,
            ),

            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
```

### Using Theme in Widgets

```dart
// In any widget
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color ?? colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Material 3 Design Tokens

Material 3 provides semantic color tokens that adapt to light/dark mode:

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `primary` | Blue 600 | Blue 200 | Key components (FAB, primary button) |
| `onPrimary` | White | Dark grey | Text on primary |
| `primaryContainer` | Light blue | Dark blue | Secondary surfaces |
| `secondary` | Teal | Teal light | Accent elements |
| `surface` | White | Dark grey | Scaffold background |
| `surfaceVariant` | Light grey | Darker grey | Card backgrounds |
| `error` | Red | Red light | Error states |
| `outline` | Grey border | Grey border | Card borders |

Using tokens instead of hardcoded colors ensures:
- Automatic light/dark adaptation
- Accessibility compliance (WCAG contrast ratios built in)
- Theming consistency across all components
- Future dynamic color support (Android 12+)

### Typography

```dart
// core/theme/app_typography.dart
class AppTypography {
  static const _interFamily = 'Inter';

  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(fontFamily: _interFamily, fontSize: 32, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontFamily: _interFamily, fontSize: 28, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: _interFamily, fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontFamily: _interFamily, fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontFamily: _interFamily, fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontFamily: _interFamily, fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontFamily: _interFamily, fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontFamily: _interFamily, fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontFamily: _interFamily, fontSize: 14, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontFamily: _interFamily, fontSize: 11, fontWeight: FontWeight.w500),
  );
}
```
