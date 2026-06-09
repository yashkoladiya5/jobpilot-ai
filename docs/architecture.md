# JobPilot AI — Architecture Documentation

> **Version:** 1.0  
> **Last Updated:** June 2026  
> **Author:** Senior Software Architect

---

## Table of Contents

1. [High-Level Architecture Overview](#1-high-level-architecture-overview)
2. [System Context Diagram](#2-system-context-diagram)
3. [Flutter Frontend Architecture](#3-flutter-frontend-architecture)
   - 3.1 [Presentation Layer](#31-presentation-layer)
   - 3.2 [Domain Layer](#32-domain-layer)
   - 3.3 [Data Layer](#33-data-layer)
   - 3.4 [Dependency Injection & Routing](#34-dependency-injection--routing)
4. [Express Backend Architecture](#4-express-backend-architecture)
   - 4.1 [Routes Layer](#41-routes-layer)
   - 4.2 [Controllers Layer](#42-controllers-layer)
   - 4.3 [Services Layer](#43-services-layer)
   - 4.4 [Middleware Layer](#44-middleware-layer)
   - 4.5 [Validators Layer](#45-validators-layer)
   - 4.6 [Config & Utils](#46-config--utils)
5. [Why Clean Architecture?](#5-why-clean-architecture)
6. [Alternatives Considered](#6-alternatives-considered)
   - 6.1 [Frontend Architecture Patterns](#61-frontend-architecture-patterns)
   - 6.2 [Backend Architecture Patterns](#62-backend-architecture-patterns)
7. [Tradeoffs & Rationale](#7-tradeoffs--rationale)
8. [Data Flow Walkthrough](#8-data-flow-walkthrough)
9. [Future Considerations](#9-future-considerations)

---

## 1. High-Level Architecture Overview

JobPilot AI is a full-stack application that follows **Clean Architecture** on the frontend and **Layered Architecture** on the backend. The guiding principle across both tiers is **separation of concerns**: each layer has a distinct responsibility, depends only on layers deeper than itself, and communicates through well-defined interfaces.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         JOBPILOT AI — SYSTEM CONTEXT                        │
│                                                                             │
│   ┌───────────────────────────────────────────────────────────┐            │
│   │                   FLUTTER APPLICATION                     │            │
│   │                                                           │            │
│   │  ┌─────────────┐  ┌──────────┐  ┌────────────────────┐   │            │
│   │  │ Presentation │─▶│  Domain  │─▶│       Data         │   │            │
│   │  │  (BLoC/UI)   │  │ (Usecase)│  │  (Repository/DS)   │   │            │
│   │  └─────────────┘  └──────────┘  └─────────┬──────────┘   │            │
│   │                                           │              │            │
│   └───────────────────────────────────────────┼──────────────┘            │
│                                               │                           │
│                                         HTTP  │  REST API                 │
│                                         (Dio) │                           │
│                                               ▼                           │
│   ┌───────────────────────────────────────────────────────────┐            │
│   │                   EXPRESS.JS SERVER                        │            │
│   │                                                           │            │
│   │  ┌──────┐  ┌────────────┐  ┌──────────┐  ┌────────────┐  │            │
│   │  │Routes│─▶│Controllers │─▶│ Services │─▶│  Prisma    │  │            │
│   │  │      │  │            │  │          │  │  ORM       │  │            │
│   │  └──────┘  └────────────┘  └──────────┘  └─────┬──────┘  │            │
│   │                                                 │        │            │
│   └─────────────────────────────────────────────────┼────────┘            │
│                                                     │                     │
│                                                     ▼                     │
│                                           ┌──────────────────┐            │
│                                           │   PostgreSQL     │            │
│                                           │   Database       │            │
│                                           └──────────────────┘            │
│                                                                           │
│   ┌────────────────────────────────────────────┐                          │
│   │           DOCKER CONTAINERS                │                          │
│   │  ┌──────────┐  ┌──────────┐  ┌─────────┐  │                          │
│   │  │  Flutter │  │ Express  │  │PostgreSQL│  │                          │
│   │  │  (Build) │  │  (Node)  │  │ (DB)    │  │                          │
│   │  └──────────┘  └──────────┘  └─────────┘  │                          │
│   └────────────────────────────────────────────┘                          │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. System Context Diagram

Below is a detailed interaction diagram showing how data flows from the user's device through the entire stack.

```
┌──────────┐       ┌────────────────────────────────────────────────────┐
│  USER    │       │                   FLUTTER APP                      │
│ (Device) │       │                                                    │
│          │       │  ┌──────────────┐    ┌────────────┐               │
│  Touch/  │──────▶│  │   UI Layer   │───▶│ BLoC Layer │               │
│  Gesture │       │  │ (Screens/Wgt)│    │ (Events/   │               │
│          │       │  └──────────────┘    │  States)   │               │
│          │       │                      └──────┬─────┘               │
│          │       │                             │                      │
│          │       │                      ┌──────▼──────┐              │
│          │       │                      │  Use Cases  │              │
│          │       │                      │  (Domain)   │              │
│          │       │                      └──────┬──────┘              │
│          │       │                             │                      │
│          │       │                      ┌──────▼──────┐              │
│          │       │                      │ Repositories│              │
│          │       │                      │ (Abstract)  │              │
│          │       │                      └──────┬──────┘              │
│          │       │                             │                      │
│          │       │                      ┌──────▼──────┐              │
│          │       │                      │  DataSources│              │
│          │       │                      │ (Dio/HTTP)  │              │
│          │       │                      └──────┬──────┘              │
│          │       └─────────────────────────────┼────────────────────┘
│          │                                     │
│          │                              HTTPS  │  REST
│          │                                     ▼
│          │       ┌────────────────────────────────────────────────────┐
│          │       │                 EXPRESS.JS API                     │
│          │       │                                                    │
│          │       │  ┌────────┐   ┌──────────┐   ┌─────────────────┐ │
│          │       │  │ Routes │──▶│Middleware│──▶│   Controllers   │ │
│          │       │  └────────┘   │ (Auth,   │   └────────┬────────┘ │
│          │       │               │  Error,  │            │          │
│          │       │               │  Multer) │            ▼          │
│          │       │               └──────────┘   ┌─────────────────┐ │
│          │       │                               │    Services     │ │
│          │       │                               └────────┬────────┘ │
│          │       │                                        │          │
│          │       │                                        ▼          │
│          │       │                               ┌─────────────────┐ │
│          │       │                               │  Prisma ORM     │ │
│          │       │                               └────────┬────────┘ │
│          │       └─────────────────────────────────────────┼─────────┘
│          │                                                 │
│          │                                          SQL    │
│          │                                                 ▼
│          │                                     ┌────────────────────┐
│          │                                     │    PostgreSQL      │
│          └─────────────────────────────────────│      Database      │
│                                                └────────────────────┘
```

### Communication Protocol

| Layer | Protocol | Format | Serialization |
|-------|----------|--------|---------------|
| Flutter → Express | HTTPS (REST) | JSON | `dart:convert` + Freezed `toJson`/`fromJson` |
| Express → Prisma | In-process method calls | JS Objects | Prisma Client |
| Prisma → PostgreSQL | TCP (PostgreSQL protocol) | Binary/SQL | Internal |

---

## 3. Flutter Frontend Architecture

The Flutter app strictly follows **Clean Architecture** as defined by Robert C. Martin, adapted for mobile:

```
lib/
├── core/                  # Shared utilities, constants, themes
│   ├── constants/
│   ├── error/             # Failures, exceptions
│   ├── network/           # Dio client, interceptors
│   ├── theme/             # Material 3 theming
│   └── utils/             # Helpers, extensions
│
├── data/                  # Data Layer
│   ├── datasources/       # Remote (API) + Local (Hive/SQLite)
│   │   ├── auth_remote_datasource.dart
│   │   ├── job_remote_datasource.dart
│   │   └── resume_remote_datasource.dart
│   ├── models/            # Data models (JSON serialization)
│   │   ├── auth_models.dart
│   │   ├── job_models.dart
│   │   └── resume_models.dart
│   └── repositories/      # Implement domain repository interfaces
│       ├── auth_repository_impl.dart
│       ├── job_repository_impl.dart
│       └── resume_repository_impl.dart
│
├── domain/                # Domain Layer (Pure Dart, no Flutter deps)
│   ├── entities/          # Core business objects
│   │   ├── user.dart
│   │   ├── job.dart
│   │   └── resume.dart
│   ├── repositories/      # Abstract repository contracts
│   │   ├── auth_repository.dart
│   │   ├── job_repository.dart
│   │   └── resume_repository.dart
│   └── usecases/          # Business logic (single-responsibility)
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
├── presentation/          # Presentation Layer
│   ├── auth/              # Auth feature
│   │   ├── bloc/          # AuthBloc, AuthEvent, AuthState
│   │   ├── pages/         # LoginPage, RegisterPage
│   │   └── widgets/       # Auth-specific widgets
│   ├── dashboard/         # Dashboard feature
│   │   ├── bloc/
│   │   ├── pages/
│   │   └── widgets/
│   ├── jobs/              # Job tracking feature
│   │   ├── bloc/
│   │   ├── pages/
│   │   └── widgets/
│   ├── resumes/           # Resume management feature
│   │   ├── bloc/
│   │   ├── pages/
│   │   └── widgets/
│   └── splash/            # Splash screen
│       └── pages/
│
├── router/                # Go Router configuration
│   ├── app_router.dart
│   └── route_names.dart
│
└── main.dart              # Entry point (DI setup, app bootstrap)
```

### 3.1 Presentation Layer

The Presentation layer contains everything related to the UI and user interaction. It comprises three sub-elements per feature:

#### BLoC (Business Logic Component)
Each feature has its own BLoC that:
- Receives **Events** from the UI (user actions like button taps, form submissions)
- Calls the appropriate **UseCase** from the domain layer
- Emits **States** that the UI listens to and renders

```
┌──────────┐    Event     ┌──────────┐   Call    ┌──────────┐
│   UI     │─────────────▶│   BLoC   │──────────▶│ UseCase  │
│ (Widget) │              │          │           │ (Domain) │
│          │◀─────────────│          │◀──────────│          │
└──────────┘   State      └──────────┘  Result   └──────────┘
```

#### BLoC Event → State Contract
Every BLoC follows a strict pattern using Freezed:

```dart
// Example: AuthBloc event/state contract
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

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.unauthenticated(String? message) = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}
```

#### Widget Organization
- **Pages**: Full screens (e.g., `LoginPage`, `DashboardPage`)
- **Widgets**: Reusable UI components (e.g., `JobCard`, `StatTile`, `CustomTextField`)
- Pages use `BlocProvider` and `BlocBuilder`/`BlocListener` to wire up BLoC
- Widgets are composed using Material 3 design tokens from the theme

### 3.2 Domain Layer

The Domain layer is the **innermost layer**—it has zero dependencies on Flutter, frameworks, or external libraries. It contains:

#### Entities
Pure Dart classes representing core business objects:

```dart
// domain/entities/job.dart
class Job {
  final String id;
  final String company;
  final String role;
  final String status; // 'saved' | 'applied' | 'interview' | 'offer' | 'rejected'
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

#### Repository Interfaces (Contracts)
Abstract classes defining what the data layer must provide:

```dart
abstract class JobRepository {
  Future<Either<Failure, List<Job>>> getJobs();
  Future<Either<Failure, Job>> getJobById(String id);
  Future<Either<Failure, Job>> createJob(CreateJobParams params);
  Future<Either<Failure, Job>> updateJob(UpdateJobParams params);
  Future<Either<Failure, void>> deleteJob(String id);
}
```

#### Use Cases
Single-responsibility classes that encapsulate one piece of business logic:

```dart
class GetJobsUsecase {
  final JobRepository repository;

  GetJobsUsecase(this.repository);

  Future<Either<Failure, List<Job>>> call() {
    return repository.getJobs();
  }
}
```

**Why single-responsibility use cases?**
- Each use case has exactly one reason to change
- They are trivial to test in isolation
- They can be composed for more complex flows
- When the BLoC needs a new operation, you add a new use case—you don't modify existing ones

### 3.3 Data Layer

The Data layer implements the repository contracts defined in the Domain layer. It manages:

#### DataSources (Remote)
- Uses **Dio** HTTP client with interceptors for:
  - JWT token injection (`AuthInterceptor`)
  - Error mapping (`ErrorInterceptor`)
  - Logging (`LogInterceptor`)
- Each data source method makes a specific API call

```dart
class JobRemoteDataSource {
  final Dio dio;

  JobRemoteDataSource(this.dio);

  Future<List<JobModel>> getJobs() async {
    final response = await dio.get('/api/jobs');
    return (response.data as List)
        .map((json) => JobModel.fromJson(json))
        .toList();
  }
}
```

#### DataSources (Local — Future)
- Planned: Hive or SQLite for offline-first support
- Local data sources will serve as cache when the network is unavailable
- Repository will implement a "network-first, cache-fallback" strategy

#### Models
- Extend domain entities with JSON serialization
- Use `fromJson`/`toJson` via Freezed code generation

#### Repository Implementations
- Implement domain repository interfaces
- Coordinate between remote and local data sources
- Map `Model` → `Entity` and vice versa
- Convert exceptions to `Failure` objects (functional error handling)

```dart
class JobRepositoryImpl implements JobRepository {
  final JobRemoteDataSource remoteDataSource;
  final JobLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  JobRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Job>>> getJobs() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteModels = await remoteDataSource.getJobs();
        final jobs = remoteModels.map((m) => m.toEntity()).toList();
        await localDataSource.cacheJobs(remoteModels);
        return Right(jobs);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localModels = await localDataSource.getCachedJobs();
        final jobs = localModels.map((m) => m.toEntity()).toList();
        return Right(jobs);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
```

### 3.4 Dependency Injection & Routing

#### Injectable / GetIt
- **Injectable** generates dependency injection code using `GetIt` service locator
- All layers are registered with their appropriate lifetime:
  - Singleton: Dio client, repositories, BLoCs
  - Factory: Use cases (stateless, can be recreated)

```dart
// Generated by Injectable — example registration
final getIt = GetIt.instance;

@module
abstract class AppModule {
  @singleton
  Dio get dio => createDioClient();

  @singleton
  AuthRemoteDataSource get authRemoteDataSource;

  @factory
  LoginUsecase get loginUsecase;

  @factory
  AuthBloc get authBloc;
}
```

#### Go Router
- Declarative routing with type-safe path parameters
- Shell routes for bottom navigation (dashboard tabs)
- Redirect guards for authentication state

```dart
final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final isLoggedIn = /* check auth state */;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    if (!isLoggedIn && !isAuthRoute) return '/auth/login';
    if (isLoggedIn && isAuthRoute) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
    GoRoute(
      path: '/auth',
      routes: [
        GoRoute(path: 'login', builder: (_, __) => const LoginPage()),
        GoRoute(path: 'register', builder: (_, __) => const RegisterPage()),
      ],
    ),
    ShellRoute(
      builder: (_, __, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
        GoRoute(path: '/jobs', builder: (_, __) => const JobsPage()),
        GoRoute(path: '/resumes', builder: (_, __) => const ResumesPage()),
      ],
    ),
  ],
);
```

---

## 4. Express Backend Architecture

The backend follows a **Layered Architecture** with strict dependency direction: Routes → Controllers → Services → Prisma ORM → PostgreSQL.

```
backend/
├── prisma/
│   ├── schema.prisma          # Database schema definition
│   └── migrations/            # Auto-generated migrations
│
├── src/
│   ├── config/
│   │   ├── database.js        # Prisma client instantiation
│   │   ├── environment.js     # Env var validation (dotenv + Joi)
│   │   └── cors.js            # CORS configuration
│   │
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── job.controller.js
│   │   └── resume.controller.js
│   │
│   ├── middleware/
│   │   ├── auth.middleware.js        # JWT verification
│   │   ├── error.middleware.js       # Global error handler
│   │   ├── upload.middleware.js      # Multer file upload
│   │   └── validate.middleware.js    # Request validation runner
│   │
│   ├── routes/
│   │   ├── index.js            # Route aggregator
│   │   ├── auth.routes.js
│   │   ├── job.routes.js
│   │   └── resume.routes.js
│   │
│   ├── services/
│   │   ├── auth.service.js
│   │   ├── job.service.js
│   │   └── resume.service.js
│   │
│   ├── validators/
│   │   ├── auth.validator.js     # Joi schemas for auth
│   │   ├── job.validator.js      # Joi schemas for jobs
│   │   └── resume.validator.js   # Joi schemas for resumes
│   │
│   ├── utils/
│   │   ├── ApiError.js           # Custom error classes
│   │   ├── ApiResponse.js        # Standardized response wrapper
│   │   ├── asyncHandler.js       # Async error wrapper
│   │   └── token.js              # JWT sign/verify helpers
│   │
│   └── app.js                    # Express app setup
│
├── server.js                     # Server entry point
├── Dockerfile
├── .env.example
└── package.json
```

### 4.1 Routes Layer

Routes are the **entry point** for HTTP requests. They:
- Define URL paths and HTTP methods
- Attach middleware (auth, validation, upload)
- Delegate to controllers — **no business logic here**

```javascript
// routes/job.routes.js
const router = require('express').Router();
const jobController = require('../controllers/job.controller');
const auth = require('../middleware/auth.middleware');
const validate = require('../middleware/validate.middleware');
const { createJobSchema, updateJobSchema } = require('../validators/job.validator');

router.use(auth); // All job routes require authentication

router.get('/',           jobController.getAll);
router.get('/:id',        jobController.getById);
router.post('/',          validate(createJobSchema), jobController.create);
router.put('/:id',        validate(updateJobSchema), jobController.update);
router.delete('/:id',     jobController.remove);

module.exports = router;
```

```javascript
// routes/index.js — Aggregator
const router = require('express').Router();

router.use('/api/auth',    require('./auth.routes'));
router.use('/api/jobs',    require('./job.routes'));
router.use('/api/resumes', require('./resume.routes'));

module.exports = router;
```

### 4.2 Controllers Layer

Controllers handle **HTTP concerns**:
- Parse request parameters, body, and headers
- Call the appropriate service method
- Format and send the HTTP response
- **No business logic** — that belongs in services

```javascript
// controllers/job.controller.js
const jobService = require('../services/job.service');
const asyncHandler = require('../utils/asyncHandler');

exports.getAll = asyncHandler(async (req, res) => {
  const userId = req.user.id;
  const { status, page, limit } = req.query;

  const result = await jobService.getAllJobs(userId, { status, page, limit });

  res.status(200).json({
    success: true,
    data: result.jobs,
    pagination: result.pagination,
  });
});

exports.create = asyncHandler(async (req, res) => {
  const userId = req.user.id;
  const jobData = req.body;

  const job = await jobService.createJob(userId, jobData);

  res.status(201).json({
    success: true,
    message: 'Job application created successfully',
    data: job,
  });
});

exports.remove = asyncHandler(async (req, res) => {
  const userId = req.user.id;
  const jobId = req.params.id;

  await jobService.deleteJob(userId, jobId);

  res.status(200).json({
    success: true,
    message: 'Job application deleted successfully',
  });
});
```

### 4.3 Services Layer

Services contain **all business logic**:
- Data validation beyond schema checks (e.g., "can this user edit this job?")
- Complex queries and aggregations via Prisma
- File processing logic
- Transaction management

```javascript
// services/job.service.js
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const ApiError = require('../utils/ApiError');

class JobService {
  async getAllJobs(userId, filters = {}) {
    const { status, page = 1, limit = 20 } = filters;
    const skip = (page - 1) * limit;

    const where = { userId };
    if (status) where.status = status;

    const [jobs, total] = await Promise.all([
      prisma.job.findMany({
        where,
        skip,
        take: limit,
        orderBy: { updatedAt: 'desc' },
        include: { resume: { select: { id: true, fileName: true } } },
      }),
      prisma.job.count({ where }),
    ]);

    return {
      jobs,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async createJob(userId, data) {
    // Business rule: limit active applications
    const activeCount = await prisma.job.count({
      where: {
        userId,
        status: { in: ['applied', 'interview'] },
      },
    });

    if (activeCount >= 50) {
      throw new ApiError(400, 'Maximum 50 active applications allowed');
    }

    return prisma.job.create({
      data: {
        ...data,
        userId,
      },
    });
  }

  async deleteJob(userId, jobId) {
    const job = await prisma.job.findUnique({ where: { id: jobId } });

    if (!job) throw new ApiError(404, 'Job application not found');
    if (job.userId !== userId) throw new ApiError(403, 'Unauthorized');

    await prisma.job.delete({ where: { id: jobId } });
  }
}

module.exports = new JobService();
```

### 4.4 Middleware Layer

Middleware handles **cross-cutting concerns**:

#### Auth Middleware
```javascript
// middleware/auth.middleware.js
const jwt = require('jsonwebtoken');
const ApiError = require('../utils/ApiError');

module.exports = (req, res, next) => {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    throw new ApiError(401, 'Authentication required');
  }

  try {
    const token = header.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    throw new ApiError(401, 'Invalid or expired token');
  }
};
```

#### Global Error Handler
```javascript
// middleware/error.middleware.js
module.exports = (err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  // Prisma known errors
  if (err.code === 'P2002') {
    return res.status(409).json({
      success: false,
      message: 'A record with this value already exists',
    });
  }

  if (err.code === 'P2025') {
    return res.status(404).json({
      success: false,
      message: 'Record not found',
    });
  }

  res.status(statusCode).json({
    success: false,
    message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};
```

#### Upload Middleware (Multer)
```javascript
// middleware/upload.middleware.js
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${Math.random().toString(36).substr(2, 9)}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  },
});

const fileFilter = (req, file, cb) => {
  const allowed = ['.pdf', '.doc', '.docx'];
  const ext = path.extname(file.originalname).toLowerCase();
  cb(null, allowed.includes(ext));
};

module.exports = multer({ storage, fileFilter, limits: { fileSize: 5 * 1024 * 1024 } });
```

#### Validation Middleware
```javascript
// middleware/validate.middleware.js
const ApiError = require('../utils/ApiError');

module.exports = (schema) => (req, res, next) => {
  const { error, value } = schema.validate(req.body, { abortEarly: false, stripUnknown: true });

  if (error) {
    const messages = error.details.map((d) => d.message).join('; ');
    throw new ApiError(400, messages);
  }

  req.body = value; // Use sanitized values
  next();
};
```

### 4.5 Validators Layer

Uses **Joi** for request body validation:

```javascript
// validators/job.validator.js
const Joi = require('joi');

const createJobSchema = Joi.object({
  company: Joi.string().required().min(1).max(200),
  role: Joi.string().required().min(1).max(200),
  status: Joi.string().valid('saved', 'applied', 'interview', 'offer', 'rejected').default('saved'),
  appliedDate: Joi.date().iso().default(() => new Date()),
  notes: Joi.string().max(2000).allow(''),
  resumeId: Joi.string().uuid(),
});

const updateJobSchema = Joi.object({
  company: Joi.string().min(1).max(200),
  role: Joi.string().min(1).max(200),
  status: Joi.string().valid('saved', 'applied', 'interview', 'offer', 'rejected'),
  appliedDate: Joi.date().iso(),
  notes: Joi.string().max(2000).allow(''),
  resumeId: Joi.string().uuid().allow(null),
}).min(1); // At least one field required
```

### 4.6 Config & Utils

#### Environment Configuration
```javascript
// config/environment.js
const dotenv = require('dotenv');
const Joi = require('joi');

dotenv.config();

const schema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
  PORT: Joi.number().default(3000),
  DATABASE_URL: Joi.string().required(),
  JWT_SECRET: Joi.string().min(32).required(),
  JWT_EXPIRES_IN: Joi.string().default('7d'),
  UPLOAD_DIR: Joi.string().default('uploads'),
  MAX_FILE_SIZE: Joi.number().default(5 * 1024 * 1024),
}).unknown();

const { error, value: env } = schema.validate(process.env);
if (error) throw new Error(`Environment validation error: ${error.message}`);

module.exports = env;
```

#### Standardized API Response
```javascript
// utils/ApiResponse.js
class ApiResponse {
  static success(res, data, message = 'Success', statusCode = 200) {
    return res.status(statusCode).json({ success: true, message, data });
  }

  static paginated(res, data, pagination, message = 'Success') {
    return res.status(200).json({ success: true, message, data, pagination });
  }
}
```

#### Async Handler
```javascript
// utils/asyncHandler.js
module.exports = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};
```

---

## 5. Why Clean Architecture?

### Testability

Clean Architecture makes the app **testable by design**:

```
┌─────────────────────────────────────────────────────────────────┐
│                    TEST STRATEGY                                 │
│                                                                  │
│  Unit Tests:        UseCase ◀── Mock Repository                  │
│                     (pure Dart, instant, no widget tree)         │
│                                                                  │
│  Widget Tests:      UI ◀── Mock BLoC (blocTest)                 │
│                     (no real API calls, no DB)                   │
│                                                                  │
│  Integration Tests: Repository ◀── Mock HTTP (Dio mock adapter) │
│                     (tests data layer in isolation)              │
│                                                                  │
│  E2E Tests:         Full stack                                  │
│                     (real API + test DB)                         │
└─────────────────────────────────────────────────────────────────┘
```

- **Domain layer has zero dependencies** — entities and use cases can be unit tested without Flutter, without Dio, without any framework
- **Repository contracts are interfaces** — the BLoC under test receives a mock repository, making tests fast and deterministic
- **Dependency Injection** via Injectable/GetIt means you swap real implementations for test doubles at the composition root

### Separation of Concerns

| Concern | Layer | Responsible For |
|---------|-------|----------------|
| UI rendering | Presentation | Widgets, animations, color, layout |
| UI logic | BLoC (Presentation) | Event handling, state management |
| Business logic | Use Cases (Domain) | Rules, computations, orchestration |
| Data contracts | Repositories (Domain) | Interface definitions |
| API communication | DataSources (Data) | HTTP calls, serialization |
| Data format | Models (Data) | JSON parsing, DB mapping |
| Entity definition | Entities (Domain) | Pure business objects |

### Scalability

- **Feature-first organization**: New features are added by creating new folders under `presentation/`, `domain/`, and `data/` — existing code is never touched
- **Single-responsibility use cases**: Adding new functionality means creating new use case classes, not bloating existing ones
- **Repository pattern**: Switching from REST to GraphQL, or adding a local cache, only affects the Data layer — the Domain and Presentation layers remain unchanged
- **BLoC is disposable**: Each BLoC is scoped to its feature; navigating away disposes it, freeing resources

---

## 6. Alternatives Considered

### 6.1 Frontend Architecture Patterns

| Pattern | Considered For | Why Rejected |
|---------|---------------|--------------|
| **MVVM (Model-View-ViewModel)** | Flutter state management | BLoC provides stricter unidirectional data flow, built-in `blocTest` support, and clearer separation between events and states. MVVM with `ChangeNotifier` leads to scattered business logic and harder-to-track state mutations. |
| **MVI (Model-View-Intent)** | Reactive UI architecture | MVI is excellent for pure reactive systems but introduces ceremony (intents → reducers → models) that is overkill for CRUD-heavy apps. BLoC provides 90% of MVI's benefits with 50% of the boilerplate. |
| **Redux (flutter_redux)** | Centralized state | Redux's single-store architecture creates performance issues in large apps (unnecessary rebuilds). BLoC allows multiple, scoped stores per feature. Redux also requires more boilerplate (actions, reducers, middleware, selectors). |
| **Riverpod** | Modern state management | Riverpod was a close contender. Ultimately, we chose BLoC because: (1) BLoC is the officially recommended pattern by the Flutter team for production apps, (2) `blocTest` provides first-class testing utilities, (3) BLoC's event-driven model maps cleanly to use cases, (4) the team has prior BLoC experience. |
| **Provider** | Simplicity | Provider is too simplistic for production apps of this scale. It lacks event-based state management, doesn't enforce unidirectional data flow, and business logic inevitably leaks into widgets. |

### 6.2 Backend Architecture Patterns

| Pattern | Considered For | Why Chosen/Rejected |
|---------|---------------|---------------------|
| **Layered Architecture** | This project | Chosen. Clear separation of concerns, well-understood by Node.js developers, maps naturally to Express.js middleware/controller/service pattern. Easy to test each layer independently. |
| **Microservices** | Scalability | Rejected. For a single-team project with a focused domain (job tracking), microservices introduce unnecessary complexity: inter-service communication, distributed transactions, service discovery, and deployment overhead. Monolith-first with clean internal layering allows extraction to microservices later if needed. |
| **Hexagonal Architecture** | Ports & Adapters | Considered but ultimately too abstract for this team size. The Layered Architecture achieves similar separation with less conceptual overhead. |
| **Serverless (AWS Lambda)** | Deployment simplicity | Rejected. Cold starts degrade UX, local development differs significantly from production, and debugging is harder. Dockerized Express provides a consistent environment from dev to prod. |
| **MVC (Model-View-Controller)** | Express apps | While most Express tutorials follow MVC, these apps typically conflate business logic in controllers. Our Layered Architecture is MVC-like but adds an explicit Service layer to keep controllers thin. |

---

## 7. Tradeoffs & Rationale

### Clean Architecture Tradeoffs

| Pro | Con |
|-----|-----|
| Maximum testability | Increased file count (4 files per feature instead of 1-2) |
| Clear separation of concerns | More boilerplate code |
| Framework-independent domain logic | Longer initial development time |
| Easy to add features | Learning curve for new team members |
| Dependency inversion | More complex DI setup |

### BLoC Tradeoffs

| Pro | Con |
|-----|-----|
| Official Flutter recommendation | More boilerplate than Provider |
| Excellent testing support (`blocTest`) | Steeper learning curve |
| Strong typing for events and states | Can be verbose for simple features |
| Built-in loading/error state patterns | Stream subscription management |
| Scoped to feature (memory efficient) | Multiple files per BLoC (event, state, bloc) |

### JWT Tradeoffs

| Pro | Con |
|-----|-----|
| Stateless — no session store needed | Cannot revoke individual tokens (without a blocklist) |
| Works across services (microservice-ready) | Token size impacts request headers |
| Standardized (RFC 7519) | Requires careful secret management |
| Mobile-friendly (no cookie dependency) | Refresh token rotation adds complexity |

### Prisma Tradeoffs

| Pro | Con |
|-----|-----|
| Type-safe queries (if using TypeScript) | Additional abstraction layer over raw SQL |
| Auto-generated migrations | Migration issues with large datasets |
| Excellent DX with IntelliSense | Performance overhead for complex queries |
| Relational data modeling | Not as mature as TypeORM for some edge cases |

### Go Router Tradeoffs

| Pro | Con |
|-----|-----|
| Declarative route definitions | Newer package, smaller community |
| Type-safe path parameters | Less documentation than Navigator 2.0 |
| Deep linking support | Custom transitions are more work |
| Redirect guards built in | Limited animation control |

---

## 8. Data Flow Walkthrough

### Complete Request Lifecycle: "User creates a job application"

```
Step 1: User taps "Save" on CreateJobPage
        │
        ▼
Step 2: CreateJobPage dispatches CreateJobEvent(data)
        │
        ▼
Step 3: JobBloc receives event, calls CreateJobUsecase
        │  • Emits JobLoading state → UI shows spinner
        ▼
Step 4: CreateJobUsecase calls JobRepository.createJob(data)
        │  • Pure business logic, no Flutter dependencies
        ▼
Step 5: JobRepositoryImpl calls JobRemoteDataSource.createJob(data)
        │  • Converts Entity → Model for JSON serialization
        ▼
Step 6: JobRemoteDataSource makes POST /api/jobs via Dio
        │  • AuthInterceptor adds Bearer token from SecureStorage
        │  • ErrorInterceptor catches HTTP errors
        ▼
Step 7: Express receives request → Auth Middleware verifies JWT
        │  • Validates signature, expiry
        │  • Attaches decoded user to req.user
        ▼
Step 8: Validation Middleware runs Joi schema on req.body
        │  • Returns 400 with field-level errors if invalid
        ▼
Step 9: JobController.create extracts userId and body
        │  • Calls jobService.createJob(userId, body)
        ▼
Step 10: JobService applies business rules
         │  • Checks active application limit
         │  • Creates job via prisma.job.create()
         ▼
Step 11: Prisma generates SQL: INSERT INTO jobs (...) VALUES (...)
         │  • Returns created job with id and timestamps
         ▼
Step 12: Response flows back through the layers
         │  • Service → Controller (201 JSON response)
         │  • Dio response → DataSource (JSON → Model)
         │  • Model → Entity (toEntity())
         │  • Repository returns Entity → UseCase → BLoC
         ▼
Step 13: BLoC receives Either<Failure, Job>
         │  • On Right: emits JobCreated(job)
         │  • On Left: emits JobError(message)
         ▼
Step 14: JobListPage rebuilds via BlocBuilder
         │  • Shows success snackbar
         │  • Navigates back to job list
         │  • List auto-updates with new job
```

---

## 9. Future Considerations

### Gemini AI Integration
- AI features will be added as new use cases in the Domain layer
- A new `GeminiService` in the backend will handle API calls
- Frontend will have a new `AI` feature folder following the same architecture
- The existing Clean Architecture makes it trivial to add: new data source → new use case → new BLoC → new UI

### Offline-First Support
- Add `Hive` or `drift` (SQLite) as a local data source
- Repository layer already designed for this (see `JobRepositoryImpl` above)
- A `NetworkInfo` abstraction will determine online/offline state
- BLoC will need to handle offline-specific states (e.g., `JobSavedOffline`)

### Push Notifications
- Firebase Cloud Messaging (FCM) integration
- New `NotificationDataSource` and `NotificationRepository`
- Background handler in Flutter
- Server-side: `NotificationService` with Firebase Admin SDK

### Web Support
- Flutter Web target
- Go Router already supports web (URL-based routing)
- CORS and cookie-based auth may need adjustment
- Responsive layout with Material 3 adaptive widgets

---

*This architecture documentation is a living document. Update it whenever significant architectural decisions are made or when the overall structure changes.*
