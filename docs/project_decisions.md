# JobPilot AI — Project Decisions Log

> **Version:** 1.0  
> **Last Updated:** June 2026  
> **Purpose:** Record every significant technical decision with context, alternatives, rationale, and tradeoffs.

---

## Table of Contents

1. [State Management: BLoC vs Riverpod vs Provider](#1-state-management-bloc-vs-riverpod-vs-provider)
2. [Immutable State: Freezed](#2-immutable-state-freezed)
3. [Dependency Injection: Injectable / GetIt](#3-dependency-injection-injectable--getit)
4. [Routing: Go Router vs Navigator 2.0](#4-routing-go-router-vs-navigator-20)
5. [HTTP Client: Dio vs http package](#5-http-client-dio-vs-http-package)
6. [Backend ORM: Prisma vs TypeORM vs Drizzle](#6-backend-orm-prisma-vs-typeorm-vs-drizzle)
7. [Authentication: JWT vs Session-based](#7-authentication-jwt-vs-session-based)
8. [File Upload Strategy](#8-file-upload-strategy)
9. [Error Handling Approach](#9-error-handling-approach)
10. [Docker Setup & Containerization](#10-docker-setup--containerization)
11. [Architecture Pattern: Clean Architecture](#11-architecture-pattern-clean-architecture)
12. [Backend Language: Node.js/Express vs alternatives](#12-backend-language-nodejsexpress-vs-alternatives)
13. [Database: PostgreSQL vs MongoDB](#13-database-postgresql-vs-mongodb)
14. [Validation: Joi vs Zod vs Yup](#14-validation-joi-vs-zod-vs-yup)
15. [Project Structure: Monorepo vs Separate Repos](#15-project-structure-monorepo-vs-separate-repos)
16. [API Design: REST vs GraphQL](#16-api-design-rest-vs-graphql)
17. [Local Storage: flutter_secure_storage vs shared_preferences](#17-local-storage-flutter_secure_storage-vs-shared_preferences)
18. [CI/CD Strategy](#18-cicd-strategy)
19. [Logging Approach](#19-logging-approach)
20. [Testing Strategy](#20-testing-strategy)

---

## 1. State Management: BLoC vs Riverpod vs Provider

### Decision
**Use `flutter_bloc` (BLoC pattern) for all state management.**

### Context
JobPilot AI requires predictable, testable state management across multiple features (auth, dashboard, jobs, resumes). The chosen solution must support:
- Unidirectional data flow
- Easy unit testing
- Feature-scoped state (not global)
- Clear separation of UI from business logic

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Provider** | Simplest state management. `ChangeNotifier` + `Provider` or `Consumer`. | Provider is too simplistic for production at this scale. It doesn't enforce unidirectional flow, business logic easily leaks into widgets via `ChangeNotifier`, and testing requires more boilerplate. No built-in event/state distinction. |
| **Riverpod** | Modern Provider successor by the same author. Compile-safe, no `BuildContext` dependency. Supports code generation. | **Close second.** Riverpod avoids BLoC's boilerplate and has excellent compile-time safety. However: (1) BLoC is an officially recommended pattern by the Flutter team, (2) `blocTest` provides superior testing ergonomics, (3) the team has existing BLoC experience, (4) BLoC's event-driven model maps more naturally to Clean Architecture use cases. Riverpod's `Notifier` pattern is great but doesn't natively distinguish between events and states the way BLoC does. |
| **MVI (Model-View-Intent)** | Reactive architecture with intents → processor → model → view. | Excellent pattern but over-engineered for a CRUD-heavy application. MVI introduces significant boilerplate (intents, reducers, models) that slows development velocity. BLoC provides 90% of MVI's deterministic state management with simpler tooling. |
| **Redux** | Single immutable store, actions dispatched through reducers. | Single store creates performance issues as the app grows (unnecessary rebuilds without careful selector optimization). Flutter Redux isn't as actively maintained as BLoC. Badly suited for scoped/feature-level state. |
| **GetX** | All-in-one framework with state management, routing, DI. | Rejected for production use due to: (1) poor architecture enforcement — encourages putting everything in controllers, (2) implicit dependencies make testing difficult, (3) community concerns about maintainability and the author's development practices, (4) violates Clean Architecture by mixing concerns. |

### Why BLoC Won

1. **Official Recommendation**: BLoC is the state management pattern officially recommended by the Flutter team for production applications.
2. **Testing**: `blocTest` package provides a declarative way to test event → state transitions:
   ```dart
   blocTest<JobBloc, JobState>(
     'emits [Loading, Loaded] when jobs are fetched successfully',
     build: () => JobBloc(getJobs: MockGetJobs()),
     act: (bloc) => bloc.add(LoadJobsEvent()),
     expect: () => [JobLoading(), JobsLoaded(testJobs)],
   );
   ```
3. **Unidirectional Flow**: Events flow in, states flow out. No widget can accidentally mutate state.
4. **Scoped Lifecycle**: BLoCs are created and disposed with their feature/route, preventing memory leaks.
5. **Clean Architecture Fit**: BLoC → UseCase → Repository maps naturally. The BLoC doesn't know about Dio, databases, or widgets.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Type-safe events and states | More boilerplate than Riverpod (3 files per BLoC: event, state, bloc) |
| Built-in loading/error patterns | Verbose for trivial features (e.g., simple toggle) |
| Excellent testing tools | Learning curve for new team members |
| Feature-scoped (efficient memory) | Stream subscription management can be tricky |
| Large community + documentation | Cannot easily compose BLoCs (unlike Riverpod's `ref.watch`) |

---

## 2. Immutable State: Freezed

### Decision
**Use `freezed` for all data classes, events, and states.**

### Context
Immutable state is essential for predictable state management and preventing unintended mutations. Flutter/Dart lacks built-in immutable data class generation.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Manual data classes** | Writing `==`, `hashCode`, `copyWith`, `toString` by hand. | Error-prone, tedious, and produces massive files. A 3-field class requires ~30 lines of boilerplate. Violates DRY. |
| **equatable** | Only provides `==` and `hashCode`. | Lacks `copyWith`, `toJson`/`fromJson`, and union types. Would need additional packages for serialization. |
| **built_value** | Immutable value types with builder pattern. | Too verbose. Requires separate builder class for each type. Poor ergonomics for union types. Slow compilation. |
| **dart_data_class** | Third-party code generator. | Smaller community, less maintained, fewer features than Freezed. |

### Why Freezed Won

1. **Single Annotation, All Features**: One `@freezed` annotation generates `==`, `hashCode`, `copyWith`, `toString`, union types, pattern matching, and (with `json_serializable`) `toJson`/`fromJson`.
2. **Union Types**: Perfect for BLoC states and events:
   ```dart
   @freezed
   sealed class AuthState with _$AuthState {
     const factory AuthState.initial() = AuthInitial;
     const factory AuthState.loading() = AuthLoading;
     const factory AuthState.authenticated(User user) = AuthAuthenticated;
     const factory AuthState.error(String message) = AuthError;
   }
   ```
3. **Pattern Matching**: Exhaustive when/switch statements ensure all states are handled (compile-time safety).
4. **JSON Serialization**: Works seamlessly with `json_serializable` for API models.
5. **Active Maintenance**: Well-maintained by the Dart/Flutter community. Used by major projects.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Eliminates boilerplate | Requires code generation step (`build_runner`) |
| Compile-time safety for unions | Generated files must be committed or regenerated |
| Excellent IDE support (with analyzer plugin) | Learning curve for union type syntax |
| Works with sealed classes (Dart 3) | Code generation can be slow on large projects |
| JSON serialization built in | Debugging generated code can be confusing |

---

## 3. Dependency Injection: Injectable / GetIt

### Decision
**Use `injectable` for code-gen DI with `get_it` as the service locator.**

### Context
Clean Architecture requires dependency inversion — concrete implementations are injected into consumers. Manual DI wiring becomes brittle as the app grows.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Manual DI (Provider)** | Manually creating and providing dependencies via `MultiProvider`. | Becomes unmanageable beyond ~5 dependencies. No dependency graph validation. Requires manual wiring on every provider change. |
| **Riverpod's `ref.watch`** | Riverpod has built-in DI via providers. | Since we chose BLoC over Riverpod for state management, using Riverpod only for DI would introduce a second state management paradigm. |
| **GetIt manually** | Using `GetIt.I.registerSingleton()` and `GetIt.I.get<T>()` everywhere. | No code generation means forgetting to register dependencies leads to runtime errors. Manual registration scatters DI configuration across files. |
| **kiwi** | Lightweight DI with code generation. | Smaller community, less documentation, fewer Flutter-specific features compared to Injectable. |

### Why Injectable Won

1. **Code Generation**: `@injectable` and `@module` annotations generate all DI registration code:
   ```dart
   @injectable
   class JobBloc extends Bloc<JobEvent, JobState> {
     // Injectable sees the constructor and auto-registers
     JobBloc({required GetJobsUsecase getJobs, required CreateJobUsecase createJob});
   }
   ```
2. **Scope Management**: Supports singleton, lazy singleton, and factory registrations.
3. **No Runtime Errors**: If a dependency can't be resolved, the build fails instead of crashing at runtime.
4. **Clean Architecture Friendly**: Each layer registers its own dependencies independently.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Compile-time safety | Generated file (`injectable.config.dart`) adds noise |
| Auto-wiring reduces manual work | Learning `@module`, `@singleton`, `@factory` annotations |
| Clear dependency graph | Code generation step required |
| Works with all DI patterns | Can't easily override dependencies in tests (must use `configureInjection` in test mode) |

---

## 4. Routing: Go Router vs Navigator 2.0

### Decision
**Use `go_router` for declarative routing.**

### Context
The app has auth-guarded routes (login/register vs dashboard), a shell with bottom navigation, and deep linking needs.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Navigator 1.0 (pushNamed)** | Imperative routing. `Navigator.pushNamed(context, '/jobs')`. | No type-safe arguments, no deep linking, no redirect guards. Requires imperative navigation logic scattered across widgets. Hard to test. |
| **Navigator 2.0** | Declarative API with `Router`, `RouteInformationParser`, `RouterDelegate`. | Extremely verbose. Implementing a simple redirect guard requires ~200 lines of boilerplate. Most teams build a wrapper (which is basically what Go Router is). |
| **Beamer** | Declarative routing with nested routing support. | Good alternative but less maintained than Go Router. Smaller community. |
| **auto_route** | Code-generated routing with type-safe arguments. | Requires code generation. Less flexible for deep linking and URL-based routing. More rigid structure. |

### Why Go Router Won

1. **Declarative Route Definitions**:
   ```dart
   GoRoute(
     path: '/jobs/:id',
     builder: (_, state) => JobDetailPage(jobId: state.pathParameters['id']!),
   )
   ```
2. **Redirect Guards Built In**: Check auth state before allowing navigation:
   ```dart
   redirect: (context, state) {
     final isLoggedIn = authBloc.state is AuthAuthenticated;
     if (!isLoggedIn) return '/auth/login';
     return null;
   }
   ```
3. **Shell Routes**: Perfect for bottom navigation without rebuilding parent:
   ```dart
   ShellRoute(
     builder: (_, __, child) => AppShell(child: child),
     routes: [/* tab routes */],
   )
   ```
4. **Deep Linking**: Works on mobile and web out of the box.
5. **No Code Generation**: Routes are plain Dart — easy to debug and maintain.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Simple declarative API | Newer than Navigator, smaller ecosystem |
| Built-in redirect guards | Custom page transitions less flexible |
| Deep linking support | Not ideal for complex nested modal flows |
| Shell routes for bottom nav | Refresh/restore behavior can be tricky |
| No code generation | Path parameters are strings (not typed without extra work) |

---

## 5. HTTP Client: Dio vs http package

### Decision
**Use `dio` for all HTTP communication.**

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **http package** | Official Dart HTTP client. | No interceptors, no request cancellation, no automatic retry, no progress tracking for uploads. Would need to manually wrap for auth token injection, error mapping, and logging. Every API call would repeat the same boilerplate. |
| **graphql client** | For GraphQL APIs. | We chose REST (see decision #16), so GraphQL-specific clients don't apply. |

### Why Dio Won

1. **Interceptors**: The single most important feature:
   - `AuthInterceptor`: Automatically injects JWT Bearer token from secure storage
   - `ErrorInterceptor`: Maps HTTP errors to Domain `Failure` objects
   - `LogInterceptor`: Debug logging in development
   - `RetryInterceptor`: Automatic retry on network failures
2. **Request Cancellation**: Cancel in-flight requests when navigating away from a page (prevents state updates on disposed BLoCs).
3. **Upload Progress**: Track file upload percentage for resume upload progress bar.
4. **Interceptors stack in order**: Adding → Removing → Logging → Error handling execute in a predictable chain.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Interceptor pipeline (auth, error, logging) | Larger package size than `http` |
| Request cancellation | More complex API for simple requests |
| Upload/download progress | Learning curve for interceptor architecture |
| Built-in timeout/config management | Overkill for apps with 1-2 API calls |
| FormData and multipart support | - |

---

## 6. Backend ORM: Prisma vs TypeORM vs Drizzle

### Decision
**Use Prisma ORM with JavaScript (not TypeScript).**

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **TypeORM** | Mature ORM with decorator-based entity definitions. | Requires TypeScript; heavy and poorly performing for complex queries; migration system is less reliable than Prisma's; active development has slowed; confusing API with multiple patterns (Active Record vs Data Mapper). |
| **Drizzle ORM** | Modern TypeScript ORM with SQL-like query syntax. | Too new (first stable release in 2024). Smaller ecosystem, fewer production deployments, less community support for troubleshooting. Requires TypeScript. Would be a top contender for a new project in 2026+. |
| **Knex.js** | SQL query builder, not a full ORM. | No migration management, no schema introspection, no type generation. Requires writing raw SQL for complex queries. Too low-level for this project's needs. |
| **Sequelize** | Older Node.js ORM. | Slower development pace; complex setup; non-intuitive API; promise-based but with callback-style error handling. Lags behind Prisma in developer experience. |
| **Mongoose** | MongoDB ODM. | Since we chose PostgreSQL (see decision #13), Mongoose doesn't apply. |

### Why Prisma Won

1. **Developer Experience**: Prisma's declarative schema → generated client flow is unmatched:
   ```prisma
   model Job {
     id     String   @id @default(uuid())
     company String
     status JobStatus @default(saved)
   }
   ```
   → Instant type-aware client: `prisma.job.findMany({ where: { status: 'applied' } })`

2. **Migration System**: Prisma Migrate generates deterministic, reviewable SQL migrations:
   ```bash
   npx prisma migrate dev --name add_status_field
   # Generates: migrations/20260601000000_add_status_field/migration.sql
   ```

3. **Schema as Source of Truth**: The `schema.prisma` file is the single source of truth for the data model. No separate entity files, no decorators.

4. **Visual Studio Code Integration**: Prisma extension provides schema visualization, auto-completion, and migration tools.

5. **JavaScript Compatibility**: Unlike TypeORM and Drizzle which require TypeScript, Prisma works well with plain JavaScript while still providing runtime type checking via the generated client.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Best-in-class DX | Database abstraction layer (raw SQL is faster for complex queries) |
| Auto-generated type-safe client | Migration issues with very large datasets (millions of rows) |
| Visual schema editor (Prisma Studio) | Memory usage can be high for complex queries |
| Declarative schema migrations | No support for some PostgreSQL-specific features (partial indexes, exclude constraints) |
| Works with JS + TS | Generated client adds to build step |
| Active development + community | Premium features in Prisma Cloud (data proxy, pulse) |

---

## 7. Authentication: JWT vs Session-based

### Decision
**Use JWT (JSON Web Tokens) with access + refresh token pattern.**

### Context
The app requires authentication for a mobile-first experience. Users should authenticate once and remain logged in for days. The auth system must work offline (for token validation on app start) and across potential future services.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Session-based (cookie)** | Server stores session in memory/Redis. Client sends session cookie. | Not ideal for mobile apps — no native cookie store, requires CSRF protection, stateful server means horizontal scaling requires shared session store. Cookie-based auth has poor mobile ergonomics. |
| **JWT only (single token)** | One long-lived JWT (e.g., 7-day expiry). | If the token is stolen, the attacker has access for 7 days. No way to revoke without a blocklist (which defeats the stateless purpose). Short-lived tokens force users to re-login too often. |
| **OAuth 2.0 / OIDC** | Third-party auth (Google, GitHub, etc.). | Adds significant complexity. Planned for future milestone, not MVP. We need our own auth system first. |

### Why JWT Won

1. **Stateless**: The server doesn't need to query a session store on every request. JWT signature verification alone confirms authenticity. This makes horizontal scaling trivial.

2. **Mobile-Friendly**: JWT is a simple string stored in `flutter_secure_storage`. No cookie management, no CSRF concerns.

3. **Two-Token Pattern**:
   - **Access token** (15 min): Short-lived, limits damage if stolen
   - **Refresh token** (7 days): Longer-lived, used to obtain new access tokens
   - Refresh tokens can be revoked (stored in DB with `isRevoked` flag), providing control when needed

4. **Standard**: RFC 7519. Every language has battle-tested JWT libraries. No lock-in.

### Token Flow

```
REGISTRATION / LOGIN
─────────────────────
Server generates:
  accessToken  = jwt.sign({ userId, email }, SECRET, { expiresIn: '15m' })
  refreshToken = jwt.sign({ userId, type: 'refresh' }, SECRET, { expiresIn: '7d' })
  → Stores refreshToken hash in DB for revocation

EVERY API REQUEST
─────────────────
Client sends:
  Authorization: Bearer <accessToken>

TOKEN REFRESH
─────────────
When access token expires:
  Client sends refresh token to POST /api/auth/refresh
  Server verifies refresh token, checks DB for revocation
  Server issues new access + refresh token pair
  Client stores new tokens

SECURITY NOTES
──────────────
- Access token contains: userId, email, iat, exp (NO password)
- Refresh token is one-time-use (rotation)
- Old refresh tokens are invalidated on rotation
- All tokens are transmitted over HTTPS only
- flutter_secure_storage uses iOS Keychain / Android EncryptedSharedPreferences
```

### Tradeoffs

| Pro | Con |
|-----|-----|
| Stateless — no DB query per request | Cannot revoke individual access tokens (must wait for expiry) |
| Mobile-first (no cookies) | Token refresh adds complexity |
| Works across services | Token size (~1KB) adds overhead to every request |
| Standardized (RFC) | Requires careful secret management |
| Refresh rotation ≈ session control | Clock skew between server and client can cause issues |

---

## 8. File Upload Strategy

### Decision
**Use Multer (multipart/form-data) with local filesystem storage, with a future migration path to S3-compatible storage.**

### Context
Users upload PDF/DOC resumes. Files must be validated, securely stored, and accessible only to the owner.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Base64 encoding** | Encode file as Base64 string, send in JSON body. | 33% size overhead. Blocks the event loop. No progress tracking. Poor UX for large files. |
| **Direct-to-S3 upload** | Client uploads directly to S3 using pre-signed URLs. | Requires S3 setup from day one. Adds CORS complexity. More moving parts before MVP. Better as a future optimization. |
| **GraphQL upload** | Multipart request specification for GraphQL. | We chose REST. GraphQL upload mutations add complexity. |
| **Streaming upload** | Node.js streams for file processing. | Over-engineered for file sizes under 5MB. Multer handles buffering and disk storage adequately. |

### Why Multer Won

1. **Simplicity**: Minimal configuration, handles multipart parsing and disk storage in one middleware.
2. **File Validation**: Built-in file size limits and file filter support.
3. **Express Integration**: `multer` is the de facto standard for Express file uploads.
4. **Filesystem Storage**: Adequate for MVP. Easy to swap to `multer-s3` later:

```javascript
// Current (local)
const storage = multer.diskStorage({ ... });

// Future (S3) — just swap the storage engine
const storage = multerS3({
  s3: new S3Client({ region: 'us-east-1' }),
  bucket: 'jobpilot-resumes',
  key: (req, file, cb) => cb(null, `${uuid()}-${file.originalname}`),
});
```

### Tradeoffs

| Pro | Con |
|-----|-----|
| Simple, well-documented | Filesystem storage doesn't scale horizontally |
| Easy validation (size, type) | Server restarts lose in-memory file buffer (disk is fine) |
| Progress tracking on frontend | Need backup/cleanup strategy for orphaned files |
| Storage engine is swappable | Multer doesn't automatically clean up failed uploads |

---

## 9. Error Handling Approach

### Decision
**Use a functional `Either<Failure, T>` pattern on the frontend and a centralized `ApiError` class with global error handler middleware on the backend.**

### Context
Errors must be handled consistently across the entire stack. The frontend needs to distinguish between error types (network, auth, validation, server) without using exceptions for control flow.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Raw exceptions** | `try/catch` everywhere, throw on error. | No type safety — you don't know what a function might throw. Easy to forget `try/catch` and crash the app. Exceptions in Dart are unchecked (no checked exceptions). |
| **Result type (dartz)** | `Either` from `dartz` functional programming package. | `dartz` is a large dependency for just `Either`. Dart 3's `sealed class` + `package:freezed` gives us the same pattern without heavy FP dependencies. |
| **Custom sealed Result** | Write our own `Result<T>` with `Success` and `Failure` variants. | Freezed already provides union types. A custom `Result` adds another concept when `Either` (from a tiny utility) suffices. |
| **Null on error** | Return `null` for failures. | Loses error information. Caller can't distinguish "not found" from "server error." Leads to silent failures. |

### Why Either<Failure, T> Won

1. **Type Safety**: The return type `Future<Either<Failure, List<Job>>>` tells you exactly what can happen — success with data OR failure with reason.
2. **Exhaustive Handling**: The BLoC must handle both cases:
   ```dart
   result.fold(
     (failure) => emit(JobError(_message(failure))),
     (jobs) => emit(JobsLoaded(jobs)),
   );
   ```
3. **No Surprises**: If it compiles, errors are being handled. No uncaught exceptions at runtime.
4. **Domain-Driven**: `Failure` is a domain concept (sealed class), not a transport concept (HTTP status code). The BLoC doesn't know about HTTP.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Compile-time guarantee all errors handled | More verbose than exceptions |
| Clear error types (domain-specific) | Learning curve for `Either` / `fold` pattern |
| No runtime crashes from unhandled errors | Can be over-engineered for simple scripts |
| Easy to test (mock both success and failure) | Requires discipline — team must consistently use the pattern |

---

## 10. Docker Setup & Containerization

### Decision
**Use Docker Compose with three services: `api` (Node.js), `db` (PostgreSQL), and an optional `flutter-builder`.**

### Docker Compose Configuration

```yaml
version: '3.8'

services:
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://jobpilot:jobpilot_pass@db:5432/jobpilot
      - JWT_SECRET=${JWT_SECRET}
      - JWT_EXPIRES_IN=7d
    volumes:
      - ./backend:/app          # Hot reload in development
      - /app/node_modules       # Don't override node_modules
      - uploads_data:/app/uploads
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=jobpilot
      - POSTGRES_PASSWORD=jobpilot_pass
      - POSTGRES_DB=jobpilot
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres_data:
  uploads_data:
```

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **No Docker** | Postgres installed locally, Node run directly. | "Works on my machine" problem. Environment differences between dev machines. Harder to onboard new developers. No production-ready deployment path. |
| **Full Docker (Flutter in Docker)** | Flutter SDK in a container for CI builds. | Flutter in Docker is slow and impractical for daily development (no emulator, hot reload doesn't work through containers). We use Docker only for the backend services. The Flutter app runs natively on the developer's machine. |
| **Docker Swarm** | Orchestration tool. | Overkill for a single-server deployment. Docker Compose is sufficient for MVP. Production will use a proper platform (Fly.io, Railway, or AWS ECS). |
| **Podman** | Rootless container alternative. | Docker is more widely used, has better tooling, and is assumed by most deployment platforms. No compelling reason to choose Podman over Docker for this project. |

### Why Docker Compose Won

1. **Environment Consistency**: Every developer runs the same PostgreSQL version, same Node version, same OS dependencies.
2. **Simplified Onboarding**: `git clone && docker compose up` = running app. No need to install PostgreSQL locally.
3. **Production Parity**: The Dockerfile used in development is the same one deployed to production.
4. **Standalone Database**: PostgreSQL runs in its own container with persistent volume storage. `docker compose down` doesn't lose data.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Consistent environments | Docker overhead on developer machines (RAM, disk) |
| Easy onboarding | Learning curve for team members new to Docker |
| Dev/prod parity | Volume mounts on macOS are slower (osxfs) |
| Isolated services | Debugging across containers is more complex |
| Easy database reset (`docker compose down -v`) | Port conflicts if other services use 3000/5432 |

---

## 11. Architecture Pattern: Clean Architecture

### Decision
**Use Clean Architecture (3-layer) on the frontend and Layered Architecture on the backend.**

### Context
JobPilot AI is a long-lived project that will evolve over years. The architecture must accommodate new features, changing API requirements, and future AI integration without requiring rewrites.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Feature-first (no layering)** | Files organized by feature only: `auth/`, `jobs/`, etc., with no layer separation. | Initially faster, but leads to spaghetti code as the app grows. Business logic mixes with UI code. Testing becomes difficult. Cannot easily swap data sources. |
| **MVC (Model-View-Controller)** | Traditional pattern. | Controllers in Flutter tend to become "God objects" with too many responsibilities. Business logic ends up in the UI layer. No clear boundary between app logic and framework. |
| **MVP (Model-View-Presenter)** | Presenter mediates between View and Model. | Similar to BLoC but without the event/state model. Presenters are harder to test than BLoCs. Less Flutter community support. |

### Why Clean Architecture Won

1. **Testability**: The domain layer has zero framework dependencies. Use cases are pure Dart classes that can be unit tested in milliseconds.
2. **Separation of Concerns**: Each layer has one job:
   - **Domain**: Business rules and entities (pure Dart)
   - **Data**: API calls, serialization, caching
   - **Presentation**: UI rendering and user interaction
3. **Dependency Inversion**: The data layer depends on domain abstractions (interfaces), not the other way around. Swap Dio for GraphQL? Just implement the repository interface differently.
4. **Feature Growth**: Adding AI integration (Gemini) means:
   - New `domain/usecases/ai/` — business logic
   - New `data/datasources/gemini_datasource.dart` — API communication
   - New `presentation/ai/` — UI
   - **No existing code changes needed**

### Tradeoffs

| Pro | Con |
|-----|-----|
| Maximum testability | Increased file count (4-5 files per feature instead of 1-2) |
| Framework-independent domain | More boilerplate code |
| Easy to add features (Open/Closed principle) | Longer initial development time |
| Clear separation of concerns | Learning curve for new developers |
| Dependencies point inward | Indirect complexity (interfaces, injections) |

---

## 12. Backend Language: Node.js/Express vs Alternatives

### Decision
**Use Node.js with Express.js (JavaScript, not TypeScript).**

### Context
The backend serves REST APIs for a mobile app. It must be simple, fast to develop, and easy to deploy.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Python (FastAPI)** | Modern Python framework with async support, auto-docs, Pydantic validation. | **Close second.** FastAPI has excellent developer experience. Rejected because: (1) the team's stronger JavaScript skills mean faster development, (2) Prisma doesn't support Python (would use SQLAlchemy which is more verbose), (3) Node.js has better library support for file uploads and JWT. |
| **Go (Gin)** | High-performance Go web framework. | Overkill for this project's traffic expectations. Go's error handling is verbose. Fewer developers available. Longer development time. |
| **Ruby on Rails** | Full-featured framework with convention over configuration. | Heavy framework. Much of Rails' value (admin panels, form builders, asset pipeline) is irrelevant for an API-only backend. Slower startup time. |
| **TypeScript (NestJS)** | Opinionated Node.js framework with TypeScript. | Adds compilation step, more boilerplate than Express. NestJS's module system is powerful but adds complexity for a focused API. TypeScript adds safety but slows initial development. We use JavaScript for faster iteration; the code is well-structured enough without type enforcement. |

### Why Node.js/Express Won

1. **JavaScript Ecosystem**: npm has the largest package registry. Every library we need (JWT, bcrypt, Multer, Joi, Prisma) has mature, well-maintained packages.
2. **Team Skills**: Strongest existing JS/Node skills.
3. **Performance**: More than adequate for this use case. Express handles thousands of requests per second on modest hardware.
4. **Rapid Development**: Express is minimal and unopinionated. Routes → Controllers → Services → Prisma is ~50 lines of boilerplate total.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Fast development cycle | No compile-time type safety (JS) |
| Largest package ecosystem | Callback-based legacy patterns in some packages |
| Excellent for REST APIs | Not the fastest runtime (but fast enough) |
| Easy debugging | Configuration over convention |
| Large talent pool | Error handling requires discipline (asyncHandler) |

---

## 13. Database: PostgreSQL vs MongoDB

### Decision
**Use PostgreSQL via Prisma ORM.**

### Context
The app stores user accounts, job applications (with status enums), and resumes (with file references). Relationships exist between these entities.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **MongoDB** | NoSQL document database. | Poor fit for relational data. Jobs, users, and resumes have clear relationships (foreign keys, joins, cascading deletes). MongoDB's schema-less nature is a liability for a project where data structure is well-defined. No native enum support. Joins are slower than PostgreSQL. |
| **SQLite** | Embedded SQL database. | Cannot scale beyond a single server. No concurrent write performance. Poor fit for multi-user API backend. |
| **MySQL** | Popular relational database. | PostgreSQL has better JSON support, better indexing, and more advanced feature set. For new projects in 2026, PostgreSQL is the consensus choice. |
| **Supabase** | Hosted PostgreSQL + backend-as-a-service. | Tempting for rapid development, but creates platform dependency. We want control over our database and migration system. Potential migration target if the team grows. |

### Why PostgreSQL Won

1. **Relational Integrity**: Users own jobs which optionally reference resumes. Foreign keys, `ON DELETE CASCADE`, and `ON DELETE SET NULL` guarantee data integrity at the database level.
2. **Enum Support**: Native `JobStatus` enum prevents invalid status values:
   ```sql
   CREATE TYPE "JobStatus" AS ENUM ('saved', 'applied', 'interview', 'offer', 'rejected');
   ```
3. **JSON Fields**: Future-proofing — if we need flexible fields (e.g., AI-generated skill tags), PostgreSQL's JSONB allows schema-less data alongside structured columns.
4. **Performance**: Excellent for read-heavy workloads with proper indexing. Connection pooling with PgBouncer when scaling.
5. **Maturity**: 30+ years of reliability. Battle-tested in production at every scale.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Data integrity (FKs, constraints) | Schema changes require migrations |
| Rich querying (JOINs, aggregations) | More complex setup than SQLite |
| Native enum + array support | Heavier than SQLite for development |
| Battle-tested, huge community | No built-in replication (requires extension) |
| JSONB for flexibility | - |

---

## 14. Validation: Joi vs Zod vs Yup

### Decision
**Use Joi for backend request validation.**

### Context
Every API request body needs validation before reaching the service layer. The validation library must be expressive, well-documented, and produce clear error messages.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Zod** | TypeScript-first schema validation. | Primarily designed for TypeScript. Since the backend uses JavaScript, Zod loses its main advantage (type inference). The API is also less mature than Joi for Express integration. |
| **Yup** | Client-side validation library. | Designed for form validation in the browser. Not ideal for API request validation. Smaller ecosystem of Express examples. |
| **Express-validator** | Express-specific validation middleware. | Less expressive schema definition. Wraps `validator.js` with middleware pattern. Schemas are harder to read and compose than Joi's fluent API. |
| **Manual validation** | `if/else` checks in every controller. | Extremely brittle. Validation logic scattered across files. No standard error format. No sanitization (e.g., stripping unknown fields). |

### Why Joi Won

1. **Express-native**: `express-joi-validation` middleware integrates seamlessly.
2. **Fluent Schema API**:
   ```javascript
   Joi.object({
     email: Joi.string().email().required(),
     password: Joi.string().min(8).max(128).required(),
   });
   ```
3. **Error Messages**: Produces human-readable, field-level error messages.
4. **Sanitization**: `stripUnknown: true` removes unexpected fields (security).
5. **Maturity**: Battle-tested in thousands of Express applications.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Mature, stable library | No TypeScript type inference (unlike Zod) |
| Express integration | Verbose for simple validations |
| Excellent error messages | Separate dependency to install |
| Schema composition (Joi.object({}).concat()) | Learning curve for advanced features (alternatives, when) |

---

## 15. Project Structure: Monorepo vs Separate Repos

### Decision
**Use a monorepo with two top-level directories: `flutter_app/` and `backend/`.**

### Structure
```
jobpilot-ai/
├── backend/
│   ├── prisma/
│   ├── src/
│   ├── Dockerfile
│   └── package.json
├── flutter_app/
│   ├── lib/
│   ├── test/
│   └── pubspec.yaml
├── docs/
├── docker-compose.yml
└── .gitignore
```

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **Separate repos** | `github.com/org/jobpilot-api` and `github.com/org/jobpilot-app`. | More overhead: two PRs for cross-cutting changes, two CI pipelines, harder to coordinate releases. Monorepo is simpler for a single team. |
| **Nx monorepo** | Nx workspace with shared libraries. | Too heavy for two loosely coupled projects. Nx excels when there are many shared packages. Flutter and Node.js don't share code. |
| **Turborepo** | JS/TS monorepo tool. | Similar to Nx — optimized for JS/TS projects. Doesn't understand Dart/Flutter. |

### Why Monorepo Won

1. **Single Source of Truth**: One repo, one issue tracker, one CI pipeline.
2. **Atomic Changes**: A backend schema change + frontend model update can be in the same PR.
3. **Shared Documentation**: `docs/` folder is accessible to both teams.
4. **Simpler Infrastructure**: One `docker-compose.yml` at the root manages everything.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Single PR for cross-cutting changes | Monorepo grows large over time |
| Shared issue tracker | Git history is noisier |
| Unified CI/CD | Can't version frontend/backend independently |
| Simpler for single team | Branch permissions are all-or-nothing |

---

## 16. API Design: REST vs GraphQL

### Decision
**Use REST (Representational State Transfer).**

### Context
The API needs to serve structured data to the Flutter client. The data model is relatively simple (users, jobs, resumes) with clear relationships.

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **GraphQL** | Query language where clients request exactly what they need. | **Considered seriously.** GraphQL would eliminate over-fetching and reduce the number of endpoints. Rejected because: (1) the data model is simple enough that REST works well, (2) GraphQL adds complexity (schema definition, resolvers, N+1 problem, caching), (3) file uploads are awkward in GraphQL (need multipart spec), (4) REST is more familiar to the team. |
| **tRPC** | End-to-end typesafe APIs. | Requires TypeScript on both client and server. Since the backend is JavaScript and the frontend is Dart, tRPC provides no type benefits across the wire. |
| **WebSockets** | Persistent connection for real-time data. | None of the current features require real-time updates. Future real-time features (notifications) could be added via WebSocket alongside REST. |

### Why REST Won

1. **Simplicity**: GET/POST/PUT/DELETE. Every developer understands REST. Tools like Postman, cURL, and automated testing frameworks work out of the box.
2. **File Uploads**: Native `multipart/form-data` support. No special GraphQL multipart specification needed.
3. **Caching**: HTTP caching (ETags, `Cache-Control`) is standard in REST. GraphQL typically uses a single POST endpoint which breaks HTTP caching.
4. **Maturity**: REST tooling is more mature — rate limiting, monitoring, documentation (Swagger/OpenAPI), and error handling patterns are well-established.
5. **Performance**: For a mobile app with structured but not deeply nested data, REST's fixed data shapes are acceptable. The dashboard endpoint already returns all needed data in one call.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Simple, universal | Fixed response shapes (some over/under-fetching) |
| Great tooling (Swagger, Postman) | Multiple endpoints for complex views |
| Native caching | Versioning is harder (URL vs header versioning) |
| Easy monitoring and logging | No built-in schema introspection (like GraphiQL) |
| Mature error handling patterns | - |

---

## 17. Local Storage: flutter_secure_storage vs shared_preferences

### Decision
**Use `flutter_secure_storage` for JWT tokens and `shared_preferences` for non-sensitive settings.**

### Context
The app needs to persist:
- **Sensitive**: JWT access token, refresh token
- **Non-sensitive**: Theme preference, onboarding completion flag, last sync timestamp

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **shared_preferences for everything** | Simple key-value storage. | **DANGEROUS.** Tokens stored in plain text on disk. On Android, this is a world-readable XML file. On iOS, plain NSUserDefaults. Any other app or attacker with file system access can read tokens. |
| **Hive** | Fast NoSQL local database. | No encryption by default. Requires additional `hive_ce` for encrypted boxes. Good for offline data, but overkill for token storage. |
| **drift (SQLite)** | Local SQL database. | Over-engineered for token storage. Planned for offline-cache feature, not for auth tokens. |
| **Keychain/Keystore directly** | Platform-specific secure storage. | Would require writing platform channels manually. `flutter_secure_storage` wraps this for us. |

### Why flutter_secure_storage Won

1. **Platform-Native Security**:
   - **iOS**: Uses iOS Keychain (hardware-backed encryption, accessible only to this app)
   - **Android**: Uses EncryptedSharedPreferences (AES-256 encrypted, key stored in Android Keystore)
2. **API Consistency**: Same `read(key)` / `write(key, value)` interface across platforms.
3. **No Dependencies Beyond**: Doesn't pull in heavy transitive dependencies.

### Tradeoffs

| Pro | Con |
|-----|-----|
| Hardware-backed encryption | Slower than plain shared_preferences |
| Platform-native security | Only supports string key-value pairs (not complex objects) |
| Simple API | Cannot store large data (>1MB) |
| Survives app reinstall (iOS Keychain) | Requires special handling for backup/restore |

---

## 18. CI/CD Strategy

### Decision
**Use GitHub Actions for CI with a two-pipeline approach: one for Flutter, one for the backend.**

### Pipeline Design

```yaml
# .github/workflows/backend.yml
name: Backend CI

on:
  push:
    branches: [main]
    paths: ['backend/**']
  pull_request:
    paths: ['backend/**']

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_USER: jobpilot
          POSTGRES_PASSWORD: jobpilot_pass
          POSTGRES_DB: jobpilot_test
        ports: ['5432:5432']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
        working-directory: ./backend
      - run: npx prisma migrate deploy
        working-directory: ./backend
        env: { DATABASE_URL: 'postgresql://jobpilot:jobpilot_pass@localhost:5432/jobpilot_test' }
      - run: npm test
        working-directory: ./backend
```

### Alternatives Considered

| Alternative | Description | Why Rejected |
|-------------|-------------|--------------|
| **GitLab CI** | Competitor to GitHub Actions. | Repo is on GitHub. GitLab CI would require a separate GitLab instance or gitlab.com repo. |
| **CircleCI** | Popular CI platform. | GitHub Actions is free for public/private repos, deeply integrated, and sufficient for this project's needs. |
| **Jenkins** | Self-hosted CI. | Operational overhead of maintaining a Jenkins server is not justified. |

### Tradeoffs

| Pro | Con |
|-----|-----|
| Free for private repos | Slower than self-hosted runners for large projects |
| Tight GitHub integration | Debugging can be harder (no local execution) |
| Matrix builds for multi-platform | Cache management for Flutter builds is finicky |
| Large marketplace of actions | 6-hour job limit (not an issue for this project) |

---

## 19. Logging Approach

### Decision
**Use `logger` package on Flutter for structured client logs and `winston` on the backend for server logs.**

### Context
Both client and server need logging, but for different purposes:
- **Client**: Debug logs for development, error reporting for production
- **Server**: Request logging, error tracking, audit trail

### Why These Libraries

| Layer | Library | Key Features |
|-------|---------|-------------|
| Flutter | `logger` | Pretty printing, log levels, JSON output, zero dependencies |
| Backend | `winston` | Transports (console, file), log levels, structured JSON, request ID tracking |

### Backend Logging Setup

```javascript
// config/logger.js
const winston = require('winston');
const path = require('path');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json(),
  ),
  transports: [
    new winston.transports.Console({
      format: process.env.NODE_ENV === 'development'
        ? winston.format.combine(winston.format.colorize(), winston.format.simple())
        : winston.format.json(),
    }),
    new winston.transports.File({
      filename: path.join(__dirname, '../../logs/error.log'),
      level: 'error',
      maxsize: 5 * 1024 * 1024, // 5MB rotation
      maxFiles: 5,
    }),
    new winston.transports.File({
      filename: path.join(__dirname, '../../logs/combined.log'),
      maxsize: 5 * 1024 * 1024,
      maxFiles: 5,
    }),
  ],
});

// Request logging middleware
const requestLogger = (req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    logger.info({
      method: req.method,
      url: req.originalUrl,
      status: res.statusCode,
      duration: Date.now() - start,
      userId: req.user?.id,
      userAgent: req.get('user-agent'),
    });
  });
  next();
};

module.exports = { logger, requestLogger };
```

### Tradeoffs

| Pro | Con |
|-----|-----|
| Structured JSON logs (Winston) | File rotation setup required |
| Request-level logging | Can log sensitive data if not careful |
| Error log separation | Disk usage from log files |
| Development-friendly colored output | Additional request overhead (microseconds) |

---

## 20. Testing Strategy

### Decision
**Use a layered testing approach: Unit → Widget → Integration → E2E, with the testing pyramid inverted for AI-generated tests.**

| Test Type | Layer(s) | Tool | Target Coverage |
|-----------|----------|------|-----------------|
| **Unit** | Domain (UseCases, Entities) | `flutter_test` + `mocktail` | 95%+ |
| **Unit** | BLoC (Event → State transitions) | `blocTest` | 90%+ |
| **Widget** | Presentation (Pages, Widgets) | `flutter_test` + `bloc_test` | 70%+ |
| **Integration** | Data (Repository + DataSource) | `flutter_test` + `mocktail` | 80%+ |
| **E2E** | Full stack | `integration_test` | Critical paths only |
| **Backend Unit** | Services + Controllers | `jest` | 90%+ |
| **Backend Integration** | API endpoints | `supertest` + test DB | 90%+ |

### Key Testing Principles

1. **Domain has zero dependencies** — Use cases and entities are pure Dart. Test without Flutter.
2. **BLoCs tested with `blocTest`** — Assert exact event → state transitions.
3. **Repositories tested with mocked DataSources** — Verify error mapping and data transformation.
4. **Backend tested with in-memory or test PostgreSQL** — Spin up test containers via Docker.
5. **Controllers tested with `supertest`** — HTTP request/response cycle without starting the full server.

### Example Test

```dart
// test/domain/usecases/get_jobs_usecase_test.dart
void main() {
  late GetJobsUsecase usecase;
  late MockJobRepository mockRepository;

  setUp(() {
    mockRepository = MockJobRepository();
    usecase = GetJobsUsecase(mockRepository);
  });

  final testJobs = [Job(id: '1', company: 'Google', role: 'Engineer', status: 'applied', appliedDate: DateTime.now())];

  test('should return jobs from repository', () async {
    when(() => mockRepository.getJobs()).thenAnswer((_) async => Right(testJobs));

    final result = await usecase.call();

    expect(result, Right(testJobs));
    verify(() => mockRepository.getJobs()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    when(() => mockRepository.getJobs()).thenAnswer((_) async => Left(ServerFailure('Network error')));

    final result = await usecase.call();

    expect(result, Left(ServerFailure('Network error')));
  });
}
```

### Tradeoffs

| Pro | Con |
|-----|-----|
| High confidence in core logic | More test code than production code (often 2:1) |
| Tests document expected behavior | Mock setup can be verbose |
| BLoC tests catch regressions instantly | Widget tests are slow |
| Backend API tests validate contracts | E2E tests are fragile and slow |
| Clean Architecture makes mocking trivial | Requires discipline to maintain test coverage |

---

## Appendix: Decision Summary Table

| # | Decision | Chosen | Key Alternatives | Primary Reason |
|---|----------|--------|-----------------|----------------|
| 1 | State management | BLoC | Riverpod, Provider | Official recommendation, testing, event-driven |
| 2 | Immutable state | Freezed | Manual, equatable, built_value | Code gen, union types, JSON |
| 3 | Dependency injection | Injectable | Manual, Riverpod | Compile-time safety, auto-wiring |
| 4 | Routing | Go Router | Navigator 2.0, auto_route | Declarative, redirect guards |
| 5 | HTTP client | Dio | http, graphql | Interceptors, cancellation |
| 6 | Backend ORM | Prisma | TypeORM, Drizzle | Developer experience, migrations |
| 7 | Authentication | JWT | Sessions, OAuth | Stateless, mobile-friendly |
| 8 | File upload | Multer | Base64, S3 direct | Simplicity, Express integration |
| 9 | Error handling | Either<Failure, T> | Raw exceptions | Type safety, exhaustive handling |
| 10 | Containerization | Docker Compose | No Docker, Swarm | Consistency, onboarding |
| 11 | Architecture | Clean Architecture | MVC, Feature-first | Testability, separation |
| 12 | Backend language | Node.js/Express | FastAPI, Go | Team skills, ecosystem |
| 13 | Database | PostgreSQL | MongoDB, SQLite | Relational integrity, enums |
| 14 | Validation | Joi | Zod, Yup | Maturity, Express integration |
| 15 | Project structure | Monorepo | Separate repos | Atomic changes |
| 16 | API design | REST | GraphQL, tRPC | Simplicity, file uploads |
| 17 | Secure storage | flutter_secure_storage | shared_preferences, Hive | Platform-native encryption |
| 18 | CI/CD | GitHub Actions | GitLab CI, CircleCI | GitHub integration, free |
| 19 | Logging | winston (BE) / logger (FE) | pino, log4dart | Structured logging |
| 20 | Testing | Unit + Widget + Integration | Manual testing | Confidence, regression prevention |

---

*This project decisions log is a living document. Every significant technical decision should be recorded here with context, alternatives, rationale, and tradeoffs. Update it whenever you make a decision that affects the project's architecture or development approach.*
