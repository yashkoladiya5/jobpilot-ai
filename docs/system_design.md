# JobPilot AI — System Design Document

> **Version:** 1.0  
> **Last Updated:** June 2026  
> **Author:** Senior Software Architect

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Authentication Flow](#2-authentication-flow)
3. [Job Tracking Flow](#3-job-tracking-flow)
4. [Dashboard Flow](#4-dashboard-flow)
5. [Resume Management Flow](#5-resume-management-flow)
6. [API Endpoint Design](#6-api-endpoint-design)
7. [Database Schema](#7-database-schema)
8. [Error Handling Strategy](#8-error-handling-strategy)
9. [State Management Design](#9-state-management-design)
10. [File Upload Design](#10-file-upload-design)
11. [Security Design](#11-security-design)

---

## 1. Introduction

This document details the **system design** of JobPilot AI, covering every data flow, API contract, database relationship, error handling strategy, and state management pattern. Where the architecture document explains *structure*, this document explains *behavior*.

---

## 2. Authentication Flow

### 2.1 Complete Auth Lifecycle

```
┌──────────────────────────────────────────────────────────────────────────────────────┐
│                           AUTHENTICATION FLOW                                        │
│                                                                                      │
│  APP START                                                                           │
│     │                                                                                │
│     ▼                                                                                │
│  ┌──────────┐    ┌──────────────────┐                                                 │
│  │  Splash  │───▶│ Check SecureStore│                                                 │
│  │  Screen  │    │ for JWT token    │                                                 │
│  └──────────┘    └────────┬─────────┘                                                 │
│                           │                                                           │
│              ┌────────────┼────────────┐                                              │
│              ▼            ▼            ▼                                              │
│           Token       Expired      No Token                                          │
│           Valid       Token                                                          │
│              │            │            │                                              │
│              ▼            ▼            ▼                                              │
│        ┌──────────┐ ┌──────────┐ ┌──────────┐                                       │
│        │Validate  │ │Refresh   │ │Navigate │                                       │
│        │Token with│ │Token via │ │to Login │                                       │
│        │  /auth/  │ │/auth/    │ │  Page   │                                       │
│        │  verify  │ │refresh   │ └────┬─────┘                                       │
│        └────┬─────┘ └────┬─────┘      │                                              │
│             │            │            │                                              │
│             ▼            │            │                                              │
│        ┌──────────┐      │            │                                              │
│        │Navigate  │◀─────┘            │                                              │
│        │to        │                    │                                              │
│        │Dashboard │                    │                                              │
│        └──────────┘                    │                                              │
│                                        ▼                                              │
│                             ┌──────────────────────┐                                 │
│                             │     Login Page        │                                 │
│                             │                       │                                 │
│                             │  User enters:         │                                 │
│                             │  • Email              │                                 │
│                             │  • Password           │                                 │
│                             │  • [Submit]           │                                 │
│                             └──────────┬───────────┘                                 │
│                                        │                                              │
│                                        ▼                                              │
│                             ┌──────────────────────┐                                 │
│                             │  LoginEvent(email,   │                                 │
│                             │  password) dispatched│                                 │
│                             │  → AuthBloc          │                                 │
│                             └──────────┬───────────┘                                 │
│                                        │                                              │
│                                        ▼                                              │
│                             ┌──────────────────────┐                                 │
│                             │  AuthBloc emits      │                                 │
│                             │  AuthLoading state   │                                 │
│                             │  → UI shows spinner  │                                 │
│                             └──────────┬───────────┘                                 │
│                                        │                                              │
│                                        ▼                                              │
│                             ┌──────────────────────┐                                 │
│                             │  LoginUsecase.call() │                                 │
│                             │  → AuthRepository    │                                 │
│                             └──────────┬───────────┘                                 │
│                                        │                                              │
│                                        ▼                                              │
│                             ┌──────────────────────┐       ┌───────────────────────┐ │
│                             │  AuthRepositoryImpl  │       │  AuthRemoteDataSource  │ │
│                             │  .login(email, pass) │──────▶│  .login(email, pass)  │ │
│                             └──────────────────────┘       └───────────┬───────────┘ │
│                                                                        │              │
│                                                                        ▼              │
│                                                     ┌──────────────────────────────┐  │
│                                                     │  Dio POST /api/auth/login    │  │
│                                                     │  Body: { email, password }   │  │
│                                                     └──────────────┬───────────────┘  │
│                                                                    │                  │
│                                                                    ▼                  │
│                                          ┌──────────────────────────────────────────┐ │
│                                          │         EXPRESS.JS AUTH FLOW            │ │
│                                          │                                          │ │
│                                          │  POST /api/auth/login                   │ │
│                                          │       │                                  │ │
│                                          │       ▼                                  │ │
│                                          │  Route → Controller → Service           │ │
│                                          │       │                                  │ │
│                                          │       ▼                                  │ │
│                                          │  AuthService.login(email, password)      │ │
│                                          │       │                                  │ │
│                                          │       ▼                                  │ │
│                                          │  prisma.user.findUnique({ where:{email}} )│ │
│                                          │       │                                  │ │
│                                          │       ▼                                  │ │
│                                          │  bcrypt.compare(password, user.password) │ │
│                                          │       │                                  │ │
│                                          │       ▼                                  │ │
│                                          │  jwt.sign({ id, email }, secret, {exp}) │ │
│                                          │       │                                  │ │
│                                          │       ▼                                  │ │
│                                          │  Response: {                             │ │
│                                          │    success: true,                        │ │
│                                          │    data: {                               │ │
│                                          │      user: { id, name, email },          │ │
│                                          │      token: "eyJhbG...",                 │ │
│                                          │      refreshToken: "eyJhbG..."           │ │
│                                          │    }                                     │ │
│                                          │  }                                       │ │
│                                          └──────────────────────────────────────────┘ │
│                                                                    │                  │
│                                                                    ▼                  │
│                             ┌──────────────────────────────────────────────────────┐  │
│                             │  DIO RESPONSE HANDLING                              │  │
│                             │                                                    │  │
│                             │  • Parse JSON → AuthModel → Auth Entity            │  │
│                             │  • Store JWT in flutter_secure_storage              │  │
│                             │  • Store refreshToken in secure storage             │  │
│                             │  • Return Either<Failure, User>                     │  │
│                             └──────────────────────┬───────────────────────────────┘  │
│                                                    │                                  │
│                                                    ▼                                  │
│                             ┌──────────────────────────────────────────────────────┐  │
│                             │  BLoC STATE TRANSITION                              │  │
│                             │                                                    │  │
│                             │  • On Right<User>: emit(AuthAuthenticated(user))    │  │
│                             │  • On Left<Failure>: emit(AuthError(message))       │  │
│                             └──────────────────────┬───────────────────────────────┘  │
│                                                    │                                  │
│                                                    ▼                                  │
│                             ┌──────────────────────────────────────────────────────┐  │
│                             │  UI REACTION                                        │  │
│                             │                                                    │  │
│                             │  BlocListener<AuthBloc, AuthState>:                 │  │
│                             │  • AuthAuthenticated → navigate to Dashboard        │  │
│                             │  • AuthError → show SnackBar                        │  │
│                             │                                                    │  │
│                             │  BlocBuilder<AuthBloc, AuthState>:                  │  │
│                             │  • AuthLoading → show CircularProgressIndicator     │  │
│                             └──────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Registration Flow

```
┌────────────┐   ┌──────────┐   ┌────────────┐   ┌──────────┐   ┌───────────┐
│ Register   │──▶│ Register │──▶│ Register   │──▶│ AuthRepo │──▶│ AuthRemote│
│ Page       │   │ Event    │   │ UseCase    │   │ Impl     │   │ DataSource│
│ (UI)       │   │ (BLoC)   │   │ (Domain)   │   │ (Data)   │   │ (Data)    │
└────────────┘   └──────────┘   └────────────┘   └──────────┘   └─────┬─────┘
                                                                       │
                                                                       ▼
                                                              ┌─────────────────┐
                                                              │ POST /api/auth/ │
                                                              │ register        │
                                                              └────────┬────────┘
                                                                       │
                                                                       ▼
                                                              ┌─────────────────┐
                                                              │ AuthController  │
                                                              │ .register()     │
                                                              └────────┬────────┘
                                                                       │
                                                                       ▼
                                                              ┌─────────────────┐
                                                              │ AuthService     │
                                                              │ .register()     │
                                                              └────────┬────────┘
                                                                       │
                                                                       ▼
                                                              ┌─────────────────┐
                                                              │ bcrypt.hash()   │
                                                              │   (cost: 12)    │
                                                              └────────┬────────┘
                                                                       │
                                                                       ▼
                                                              ┌─────────────────┐
                                                              │ prisma.user     │
                                                              │ .create()       │
                                                              └────────┬────────┘
                                                                       │
                                                                       ▼
                                                              ┌─────────────────┐
                                                              │ Response:       │
                                                              │ 201 Created     │
                                                              │ + JWT token     │
                                                              └─────────────────┘
```

### 2.3 Token Refresh Flow

```
┌──────────────┐    401 Unauthorized     ┌──────────────────┐
│  Dio Request │────────────────────────▶│ AuthInterceptor  │
│  (any API)   │                         │ (Dio interceptor)│
└──────────────┘                         └────────┬─────────┘
                                                  │
                                                  ▼
                                   ┌──────────────────────────┐
                                   │ Read refreshToken from   │
                                   │ SecureStorage            │
                                   └────────────┬─────────────┘
                                                  │
                                                  ▼
                                   ┌──────────────────────────┐
                                   │ POST /api/auth/refresh   │
                                   │ Body: { refreshToken }   │
                                   └────────────┬─────────────┘
                                                  │
                                                  ▼
                                   ┌──────────────────────────┐
                                   │ AuthService.refresh()     │
                                   │ • Verify refresh token   │
                                   │ • Issue new access token │
                                   │ • Issue new refresh token│
                                   └────────────┬─────────────┘
                                                  │
                                                  ▼
                                   ┌──────────────────────────┐
                                   │ Store new tokens          │
                                   │ Retry original request    │
                                   │ with new access token     │
                                   └──────────────────────────┘
```

### 2.4 Auth Data Structures

```dart
// Flutter — Auth Models (Freezed)

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required User user,
    required String token,
    required String refreshToken,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
```

---

## 3. Job Tracking Flow

### 3.1 Job CRUD Lifecycle

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                         JOB TRACKING — FULL LIFECYCLE                           │
│                                                                                │
│  ┌──────────────┐                                                              │
│  │  Jobs Page   │──▶ User taps FAB (+)                                        │
│  │  (List View) │                                                              │
│  └──────┬───────┘                                                              │
│         │                                                                      │
│         ▼                                                                      │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────────┐                 │
│  │CreateJobPage │───▶│ Save button  │───▶│ CreateJobEvent   │                 │
│  │ (Form)       │    │ tapped       │    │ dispatched → BLoC│                 │
│  └──────────────┘    └──────────────┘    └────────┬─────────┘                 │
│                                                   │                           │
│                                                   ▼                           │
│                                          ┌──────────────────┐                 │
│                                          │ CreateJobUseCase │                 │
│                                          │ .call(params)     │                 │
│                                          └────────┬─────────┘                 │
│                                                   │                           │
│                                                   ▼                           │
│                                          ┌──────────────────┐                 │
│                                          │ JobRepository    │                 │
│                                          │ .createJob(data)  │                 │
│                                          └────────┬─────────┘                 │
│                                                   │                           │
│                                                   ▼                           │
│                                          ┌──────────────────┐                 │
│                                          │ JobRemoteDS      │                 │
│                                          │ .createJob(data)  │                 │
│                                          └────────┬─────────┘                 │
│                                                   │                           │
│                                                   ▼                           │
│                                          ┌──────────────────────────────────┐ │
│                                          │  POST /api/jobs                  │ │
│                                          │  Body: {                        │ │
│                                          │    company: "Google",           │ │
│                                          │    role: "Software Engineer",   │ │
│                                          │    status: "applied",           │ │
│                                          │    appliedDate: "2026-06-01",   │ │
│                                          │    notes: "Referred by John",   │ │
│                                          │    resumeId: "uuid-here"        │ │
│                                          │  }                              │ │
│                                          └────────┬─────────────────────────┘ │
│                                                   │                           │
│                                                   ▼                           │
│                                          ┌──────────────────────────────────┐ │
│                                          │  EXPRESS.JS                     │ │
│                                          │                                  │ │
│                                          │  Route → AuthMW → ValidateMW    │ │
│                                          │  → JobController.create()       │ │
│                                          │  → JobService.createJob()       │ │
│                                          │  → prisma.job.create()          │ │
│                                          │  → Response: 201 + job object   │ │
│                                          └────────┬─────────────────────────┘ │
│                                                   │                           │
│                                                   ▼                           │
│                                          ┌──────────────────────────────────┐ │
│                                          │  FLUTTER HANDLING               │ │
│                                          │                                  │ │
│                                          │  Dio returns JSON               │ │
│                                          │  → JobModel.fromJson()           │ │
│                                          │  → .toEntity() → Job             │ │
│                                          │  → Right(Job)                    │ │
│                                          │                                  │ │
│                                          │  BLoC emits:                    │ │
│                                          │  JobCreated(Job job)             │ │
│                                          │                                  │ │
│                                          │  UI reacts:                     │ │
│                                          │  • Show success SnackBar         │ │
│                                          │  • Pop back to JobsPage          │ │
│                                          │  • JobsPage fetches fresh list   │ │
│                                          └──────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Job List with Filters & Pagination

```
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│  JobsPage    │───▶│ getJobs()     │───▶│ LoadJobsEvent    │
│  initState() │    │ triggered     │    │ dispatched      │
└──────────────┘    └──────────────┘    └────────┬─────────┘
                                                  │
                                                  ▼
                              ┌────────────────────────────────────┐
                              │            JobBloc                  │
                              │                                    │
                              │  mapEventToState(LoadJobsEvent) {  │
                              │    yield JobLoading();             │
                              │    final result = await            │
                              │      getJobsUsecase.call();         │
                              │    yield result.fold(              │
                              │      (failure) => JobError(fail),  │
                              │      (jobs) => JobsLoaded(jobs),   │
                              │    );                               │
                              │  }                                 │
                              └────────┬───────────────────────────┘
                                       │
                                       ▼
                  ┌─────────────────────────────────────────────────────┐
                  │              GET /api/jobs?status=applied&page=1     │
                  │                 &limit=20&sortBy=updatedAt           │
                  │                                                     │
                  │  Response: {                                        │
                  │    success: true,                                   │
                  │    data: [ { job1 }, { job2 }, ... ],               │
                  │    pagination: {                                    │
                  │      page: 1,                                       │
                  │      limit: 20,                                     │
                  │      total: 47,                                     │
                  │      totalPages: 3                                  │
                  │    }                                                │
                  │  }                                                  │
                  └─────────────────────────────────────────────────────┘
                                       │
                                       ▼
                  ┌─────────────────────────────────────────────────────┐
                  │  UI:                                               │
                  │  ┌─────────────────────────────────────────┐       │
                  │  │  🔍 [Search...]    ▼ Status: All        │       │
                  │  ├─────────────────────────────────────────┤       │
                  │  │ ┌─────┐  ┌───────────────┐  ┌────────┐ │       │
                  │  │ │ 47  │  │  8 Applied    │  │ 3      │ │       │
                  │  │ │Total│  │  5 Interview  │  │Interview│ │       │
                  │  │ └─────┘  │  2 Offer      │  │  this  │ │       │
                  │  │          │  1 Rejected   │  │  week  │ │       │
                  │  │          └───────────────┘  └────────┘ │       │
                  │  ├─────────────────────────────────────────┤       │
                  │  │ ┌─────────────────────────────────────┐ │       │
                  │  │ │ Google  │ Software Eng  │ Applied   │ │       │
                  │  │ │ Jun 01  │               │ ▶         │ │       │
                  │  │ ├─────────────────────────────────────┤ │       │
                  │  │ │ Stripe  │ iOS Dev       │ Interview │ │       │
                  │  │ │ May 28  │               │ ▶         │ │       │
                  │  │ ├─────────────────────────────────────┤ │       │
                  │  │ │ Apple   │ Frontend      │ Saved     │ │       │
                  │  │ │ May 25  │               │ ▶         │ │       │
                  │  │ └─────────────────────────────────────┘ │       │
                  │  │                                         │       │
                  │  │  ◀ 1  2  3 ... ▶                        │       │
                  │  └─────────────────────────────────────────┘       │
                  └─────────────────────────────────────────────────────┘
```

### 3.3 Job Status Transitions

```
                    ┌─────────┐
                    │  SAVED  │
                    └────┬────┘
                         │
                         ▼
                    ┌──────────┐
              ┌────▶│ APPLIED  │◀────┐
              │     └─────┬────┘     │
              │           │          │
              │           ▼          │
              │     ┌───────────┐    │
              │     │ INTERVIEW │    │
              │     └─────┬─────┘    │
              │           │          │
              │     ┌─────┴──────┐   │
              │     ▼            ▼   │
              │ ┌──────┐    ┌──────┐ │
              │ │ OFFER│    │REJECT│ │
              │ └──┬───┘    └──────┘ │
              │    │                 │
              └────┘                 │
          (Offer declined → Applied) │
                                     │
          All states → Rejected      │
          can come from any state    │
          (e.g., rejected after      │
           interview)                │
                                     │
          Only SAVED → can be deleted│
          Applied+ → must be Archived│
```

---

## 4. Dashboard Flow

### 4.1 Dashboard Composition

```
┌────────────────────────────────────────────────────────────────────────────┐
│                             DASHBOARD PAGE                                  │
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  HEADER                                                              │  │
│  │  ┌──────┐  Good morning, Yash!                                      │  │
│  │  │  👤  │  You have 3 interviews this week                          │  │
│  │  └──────┘                                                            │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌──────┬──────┬──────┬──────┬──────┐                                     │
│  │ TOTAL│ACTIVE│INTERV│ OFFER│REJECT│  ← Stat Cards (animated counters)  │
│  │  47  │  13  │ 5    │  2   │  3   │                                     │
│  └──────┴──────┴──────┴──────┴──────┘                                     │
│                                                                             │
│  ┌──────────────────────────────────────────────────────┐                  │
│  │  RECENT APPLICATIONS              [View All ▶]       │                  │
│  │                                                     │                  │
│  │  ┌────────┬────────────┬──────────┬────────────────┐│                  │
│  │  │Company │ Role        │ Status   │ Date          ││                  │
│  │  ├────────┼────────────┼──────────┼────────────────┤│                  │
│  │  │ Google │ SWE         │ ● Applied│ 2026-06-01    ││                  │
│  │  │ Stripe │ iOS Dev     │ ● Interv │ 2026-05-28    ││                  │
│  │  │ Apple  │ Frontend    │ ● Saved  │ 2026-05-25    ││                  │
│  │  │ Meta   │ Backend     │ ● Offer  │ 2026-05-20    ││                  │
│  │  └────────┴────────────┴──────────┴────────────────┘│                  │
│  └──────────────────────────────────────────────────────┘                  │
│                                                                             │
│  ┌──────────────────────┐   ┌──────────────────────────┐                  │
│  │  STATUS DISTRIBUTION │   │  APPLICATIONS OVER TIME   │                  │
│  │                      │   │                          │                  │
│  │     ┌────┐ Applied   │   │   ██                     │                  │
│  │     │ ██ │ (13)      │   │   ██ ██                  │                  │
│  │     │ ██ │ Interview │   │   ██ ██ ██               │                  │
│  │     │ ██ │ (5)       │   │   ██ ██ ██ ██            │                  │
│  │     │ ██ │ Offer (2) │   │   ██ ██ ██ ██ ██         │                  │
│  │     └────┘           │   │   May 22  May 29  Jun 05 │                  │
│  │                      │   │                          │                  │
│  └──────────────────────┘   └──────────────────────────┘                  │
│                                                                             │
│  ┌──────────────────────────────────────────────────────┐                  │
│  │  UPCOMING INTERVIEWS                                 │                  │
│  │                                                     │                  │
│  │  📅 Tomorrow 10:00 AM — Google (Phone Screen)       │                  │
│  │  📅 Jun 12, 2:00 PM — Stripe (System Design)        │                  │
│  │  📅 Jun 15, 11:00 AM — Apple (On-site)              │                  │
│  └──────────────────────────────────────────────────────┘                  │
└────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Dashboard Data Flow

```
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│  Dashboard   │───▶│ DashboardInit│───▶│ DashboardBloc    │
│  Page enters │    │ Event        │    │ .mapEventToState │
│  viewport    │    │ dispatched   │    └────────┬─────────┘
└──────────────┘    └──────────────┘             │
                                                  │  (parallel calls)
                  ┌───────────────────────────────┼───────────────────────┐
                  │                               │                       │
                  ▼                               ▼                       ▼
      ┌────────────────────┐         ┌────────────────────┐   ┌────────────────────┐
      │ GetStatsUsecase    │         │ GetRecentJobsUC    │   │ GetUpcomingInterv. │
      │ .call()            │         │ .call(limit: 5)     │   │ .call()            │
      └────────┬───────────┘         └────────┬───────────┘   └────────┬───────────┘
               │                              │                        │
               ▼                              ▼                        ▼
      ┌────────────────────┐         ┌────────────────────┐   ┌────────────────────┐
      │ JobRepository      │         │ JobRepository      │   │ JobRepository      │
      │ .getStats()        │         │ .getRecentJobs()   │   │ .getUpcomingIntv() │
      └────────┬───────────┘         └────────┬───────────┘   └────────┬───────────┘
               │                              │                        │
               ▼                              ▼                        ▼
      ┌────────────────────┐         ┌────────────────────┐   ┌────────────────────┐
      │ GET /api/jobs/     │         │ GET /api/jobs?     │   │ GET /api/jobs?     │
      │ stats              │         │ limit=5&sortBy=    │   │ status=interview& │
      │                    │         │ updatedAt&order=   │   │ sortBy=interview  │
      │ Response: {        │         │ desc               │   │ Date&order=asc    │
      │   total: 47,       │         │                    │   │                    │
      │   applied: 13,     │         │ Response: [jobs]   │   │ Response: [jobs]   │
      │   interview: 5,    │         │                    │   │                    │
      │   offer: 2,        │         │                    │   │                    │
      │   rejected: 3      │         │                    │   │                    │
      │ }                  │         │                    │   │                    │
      └────────────────────┘         └────────────────────┘   └────────────────────┘
               │                              │                        │
               └──────────────┬───────────────┴───────────────┬────────┘
                              │                               │
                              ▼                               ▼
                  ┌──────────────────────┐        ┌──────────────────────┐
                  │  DashboardBloc       │        │  DashboardBloc       │
                  │  emits state with    │        │  emits state with    │
                  │  stats, recentJobs,  │        │  stats, recentJobs,  │
                  │  upcomingInterviews  │        │  upcomingInterviews  │
                  └──────────┬───────────┘        └──────────┬───────────┘
                             │                               │
                             ▼                               ▼
                  ┌─────────────────────────────────────────────────────────┐
                  │  UI rebuilds with fresh data                            │
                  │                                                        │
                  │  BlocBuilder<DashboardBloc, DashboardState> {          │
                  │    when DashboardLoaded:                               │
                  │      → StatsRow(state.stats)                           │
                  │      → RecentJobsList(state.recentJobs)                │
                  │      → UpcomingInterviews(state.upcomingInterviews)    │
                  │    when DashboardError:                                │
                  │      → ErrorBanner(state.message) + RetryButton        │
                  │  }                                                     │
                  └─────────────────────────────────────────────────────────┘
```

---

## 5. Resume Management Flow

### 5.1 Resume Upload Flow

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         RESUME UPLOAD FLOW                                    │
│                                                                              │
│  USER ACTION                    FLUTTER APP                    EXPRESS API  │
│                                                                              │
│  ┌─────────────┐                                                            │
│  │ Tap "Upload  │                                                            │
│  │ Resume"     │                                                            │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         ▼                                                                   │
│  ┌─────────────┐      ┌──────────────────┐                                 │
│  │ File Picker  │─────▶│ Selected File:   │                                 │
│  │ Opens        │      │ resume_2026.pdf  │                                 │
│  │ (pickPDF)    │      │ Size: 2.4 MB    │                                 │
│  └─────────────┘      │ Type: PDF        │                                 │
│                        └────────┬─────────┘                                 │
│                                 │                                           │
│                                 ▼                                           │
│                        ┌──────────────────┐                                │
│                        │ UploadResumeEvent│                                │
│                        │ dispatched       │                                │
│                        │ → ResumeBloc     │                                │
│                        └────────┬─────────┘                                │
│                                 │                                           │
│                                 ▼                                           │
│                        ┌──────────────────┐                                │
│                        │ UploadResumeUC   │                                │
│                        │ .call(File)      │                                │
│                        └────────┬─────────┘                                │
│                                 │                                           │
│                                 ▼                                           │
│                        ┌──────────────────┐                                │
│                        │ ResumeRepository │                                │
│                        │ .upload(file)    │                                │
│                        └────────┬─────────┘                                │
│                                 │                                           │
│                                 ▼                                           │
│                        ┌──────────────────┐     ┌─────────────────────────┐│
│                        │ ResumeRemoteDS   │────▶│ FormData with           ││
│                        │ .upload(file)    │     │ MultipartFile           ││
│                        └──────────────────┘     │ [file bytes]            ││
│                                                  └───────────┬─────────────┘│
│                                                              │              │
│                                                              ▼              │
│                                              ┌─────────────────────────────┐│
│                                              │  POST /api/resumes/upload   ││
│                                              │  Content-Type: multipart/   ││
│                                              │  form-data                  ││
│                                              │  Body: resume=<file>        ││
│                                              └─────────────┬───────────────┘│
│                                                            │                │
│                                                            ▼                │
│                                              ┌─────────────────────────────┐│
│                                              │  EXPRESS.JS UPLOAD FLOW    ││
│                                              │                             ││
│                                              │  1. Auth Middleware         ││
│                                              │     → Verify JWT            ││
│                                              │                             ││
│                                              │  2. Upload Middleware       ││
│                                              │     → Multer processes     ││
│                                              │       multipart/form-data  ││
│                                              │     → Validates:           ││
│                                              │       • File type (PDF/DOC)││
│                                              │       • File size (<5MB)   ││
│                                              │     → Saves to uploads/    ││
│                                              │       dir with unique name ││
│                                              │                             ││
│                                              │  3. ResumeController       ││
│                                              │     .upload(req, res)      ││
│                                              │                             ││
│                                              │  4. ResumeService          ││
│                                              │     .upload(userId, file)  ││
│                                              │                             ││
│                                              │  5. prisma.resume.create() ││
│                                              │     {                      ││
│                                              │       userId,              ││
│                                              │       fileName: original,  ││
│                                              │       filePath: stored,    ││
│                                              │       fileSize: bytes,     ││
│                                              │       mimeType: pdf,       ││
│                                              │     }                      ││
│                                              │                             ││
│                                              │  6. Response 201:          ││
│                                              │     { resume object }      ││
│                                              └─────────────┬───────────────┘│
│                                                            │                │
│                                                            ▼                │
│                        ┌──────────────────────────────────────────────────┐ │
│                        │  FLUTTER HANDLING                                │ │
│                        │                                                  │ │
│                        │  • Dio receives response                         │ │
│                        │  • Parse JSON → ResumeModel                      │ │
│                        │  • Map to Entity → Resume                        │ │
│                        │  • Return Right(Resume)                          │ │
│                        │                                                  │ │
│                        │  BLoC emits: ResumeUploaded(resume)              │ │
│                        │  UI shows success + adds to list                 │ │
│                        └──────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 5.2 Resume Management Page

```
┌────────────────────────────────────────────────────────────────────────────┐
│                         RESUME MANAGEMENT                                   │
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  HEADER                                                              │  │
│  │  ┌────────────────────────────────────────────┐  ┌───────────────┐  │  │
│  │  │  My Resumes                                │  │ [+ Upload]    │  │  │
│  │  │  Manage your resume files                  │  └───────────────┘  │  │
│  │  └────────────────────────────────────────────┘                     │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  ┌──────────────────────────────────────────────────────────────┐   │  │
│  │  │  resume_2026.pdf                      📄 2.4 MB  Jun 01     │   │  │
│  │  │  ┌──────┐ ┌──────┐ ┌──────────┐ ┌──────────┐               │   │  │
│  │  │  │View  │ │Download│ │Link to  │ │  Delete  │               │   │  │
│  │  │  └──────┘ └──────┘ │ Jobs (3) │ └──────────┘               │   │  │
│  │  │                     └──────────┘                            │   │  │
│  │  ├──────────────────────────────────────────────────────────────┤   │  │
│  │  │  Resume_Stripe_2026.pdf              📄 1.8 MB  May 20      │   │  │
│  │  │  ┌──────┐ ┌──────┐ ┌──────────┐ ┌──────────┐               │   │  │
│  │  │  │View  │ │Download│ │Link to  │ │  Delete  │               │   │  │
│  │  │  └──────┘ └──────┘ │ Jobs (1) │ └──────────┘               │   │  │
│  │  │                     └──────────┘                            │   │  │
│  │  └──────────────────────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────────┘
```

### 5.3 Resume Service (Backend)

```javascript
// services/resume.service.js
const prisma = require('../config/database');
const ApiError = require('../utils/ApiError');
const path = require('path');
const fs = require('fs/promises');

class ResumeService {
  async uploadResume(userId, file) {
    if (!file) throw new ApiError(400, 'No file provided');

    // Business rule: max 10 resumes per user
    const count = await prisma.resume.count({ where: { userId } });
    if (count >= 10) {
      // Clean up uploaded file
      await fs.unlink(file.path);
      throw new ApiError(400, 'Maximum 10 resumes allowed. Delete an existing one first.');
    }

    return prisma.resume.create({
      data: {
        userId,
        fileName: file.originalname,
        filePath: file.path,
        fileSize: file.size,
        mimeType: file.mimetype,
      },
    });
  }

  async getResumes(userId) {
    return prisma.resume.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      include: {
        _count: { select: { jobs: true } }, // Count linked jobs
      },
    });
  }

  async deleteResume(userId, resumeId) {
    const resume = await prisma.resume.findUnique({ where: { id: resumeId } });
    if (!resume) throw new ApiError(404, 'Resume not found');
    if (resume.userId !== userId) throw new ApiError(403, 'Unauthorized');

    // Delete file from disk
    await fs.unlink(resume.filePath).catch(() => {});

    await prisma.resume.delete({ where: { id: resumeId } });
  }
}

module.exports = new ResumeService();
```

---

## 6. API Endpoint Design

### 6.1 Complete API Reference

| Method | Endpoint | Auth | Request Body | Response | Description |
|--------|----------|------|-------------|----------|-------------|
| `POST` | `/api/auth/register` | No | `{ name, email, password }` | `201: { user, token, refreshToken }` | Create account |
| `POST` | `/api/auth/login` | No | `{ email, password }` | `200: { user, token, refreshToken }` | Sign in |
| `POST` | `/api/auth/refresh` | No | `{ refreshToken }` | `200: { token, refreshToken }` | Refresh JWT |
| `POST` | `/api/auth/logout` | Yes | `{ refreshToken }` | `200: { message }` | Invalidate session |
| `GET` | `/api/auth/me` | Yes | — | `200: { user }` | Get current user |
| | | | | | |
| `GET` | `/api/jobs` | Yes | Query: `status`, `page`, `limit`, `sortBy`, `order`, `search` | `200: { jobs[], pagination }` | List jobs |
| `GET` | `/api/jobs/stats` | Yes | — | `200: { total, applied, interview, offer, rejected }` | Get job stats |
| `GET` | `/api/jobs/recent` | Yes | Query: `limit` | `200: { jobs[] }` | Recent jobs |
| `GET` | `/api/jobs/upcoming` | Yes | — | `200: { jobs[] }` | Upcoming interviews |
| `GET` | `/api/jobs/:id` | Yes | — | `200: { job }` | Get job by ID |
| `POST` | `/api/jobs` | Yes | `{ company, role, status, appliedDate?, notes?, resumeId? }` | `201: { job }` | Create job |
| `PUT` | `/api/jobs/:id` | Yes | `{ company?, role?, status?, appliedDate?, notes?, resumeId? }` | `200: { job }` | Update job |
| `DELETE` | `/api/jobs/:id` | Yes | — | `200: { message }` | Delete job |
| | | | | | |
| `GET` | `/api/resumes` | Yes | — | `200: { resumes[] }` | List resumes |
| `POST` | `/api/resumes/upload` | Yes | `multipart: resume=<file>` | `201: { resume }` | Upload resume |
| `DELETE` | `/api/resumes/:id` | Yes | — | `200: { message }` | Delete resume |
| `GET` | `/api/resumes/:id/download` | Yes | — | `200: file stream` | Download resume |

### 6.2 Standard Response Envelope

All API responses follow a consistent envelope:

```javascript
// Success Response
{
  "success": true,
  "message": "Job application created successfully",
  "data": { /* resource object */ },
  "pagination": {                    // Only for list endpoints
    "page": 1,
    "limit": 20,
    "total": 47,
    "totalPages": 3
  }
}

// Error Response
{
  "success": false,
  "message": "Validation failed",
  "errors": [                       // Only for validation errors
    { "field": "email", "message": "Email is required" },
    { "field": "password", "message": "Password must be at least 8 characters" }
  ]
}
```

### 6.3 HTTP Status Code Usage

| Code | Usage | Example |
|------|-------|---------|
| `200` | Successful GET, PUT, DELETE | Job updated, list fetched |
| `201` | Successful POST (resource created) | Job created, user registered |
| `400` | Bad request / validation failure | Invalid email format, missing field |
| `401` | Unauthenticated | Missing/invalid/expired JWT |
| `403` | Forbidden | User trying to delete another user's job |
| `404` | Resource not found | Job ID doesn't exist |
| `409` | Conflict | Email already registered (unique constraint) |
| `413` | Payload too large | File exceeds 5MB limit |
| `422` | Unprocessable entity | Business rule violation (e.g., >50 active apps) |
| `429` | Rate limited | Too many requests |
| `500` | Internal server error | Unhandled exception |

---

## 7. Database Schema

### 7.1 Entity Relationship Diagram (ASCII)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DATABASE SCHEMA — JOBPILOT AI                      │
│                                                                             │
│  ┌──────────────────────────┐                                              │
│  │          USER            │                                              │
│  ├──────────────────────────┤                                              │
│  │ id            UUID  PK   │──┐                                           │
│  │ name          VARCHAR(100)│  │                                           │
│  │ email         VARCHAR(255)│  │  UNIQUE                                   │
│  │ passwordHash  VARCHAR(255)│  │  bcrypt hashed                            │
│  │ createdAt     DateTime    │  │                                           │
│  │ updatedAt     DateTime    │  │                                           │
│  └──────────────────────────┘  │                                           │
│                                │                                           │
│  ┌──────────────────────────┐  │                                           │
│  │           JOB            │  │                                           │
│  ├──────────────────────────┤  │                                           │
│  │ id            UUID  PK   │  │                                           │
│  │ userId        UUID  FK   │──┘  (User → Job : 1 → N)                   │
│  │ company       VARCHAR(200)│                                              │
│  │ role          VARCHAR(200)│                                              │
│  │ status        Enum       │  'saved','applied','interview','offer','rej'│
│  │ appliedDate   Date       │                                              │
│  │ notes         TEXT?      │                                              │
│  │ resumeId      UUID  FK?  │──┐  (Resume → Job : 1 → N)                 │
│  │ createdAt     DateTime   │  │                                           │
│  │ updatedAt     DateTime   │  │                                           │
│  └──────────────────────────┘  │                                           │
│                                │                                           │
│  ┌──────────────────────────┐  │                                           │
│  │         RESUME           │  │                                           │
│  ├──────────────────────────┤  │                                           │
│  │ id            UUID  PK   │  │                                           │
│  │ userId        UUID  FK   │──┘  (User → Resume : 1 → N)                │
│  │ fileName      VARCHAR(255)│                                              │
│  │ filePath      VARCHAR(500)│                                              │
│  │ fileSize      Int        │                                              │
│  │ mimeType      VARCHAR(50)│                                              │
│  │ createdAt     DateTime   │                                              │
│  │ updatedAt     DateTime   │                                              │
│  └──────────────────────────┘                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7.2 Prisma Schema

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id           String   @id @default(uuid()) @db.Uuid
  name         String   @db.VarChar(100)
  email        String   @unique @db.VarChar(255)
  passwordHash String   @db.VarChar(255)
  createdAt    DateTime @default(now())
  updatedAt    DateTime @updatedAt

  jobs    Job[]
  resumes Resume[]

  @@map("users")
}

model Job {
  id          String   @id @default(uuid()) @db.Uuid
  userId      String   @db.Uuid
  company     String   @db.VarChar(200)
  role        String   @db.VarChar(200)
  status      JobStatus @default(saved)
  appliedDate DateTime @default(now()) @db.Date
  notes       String?  @db.Text
  resumeId    String?  @db.Uuid
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  user   User    @relation(fields: [userId], references: [id], onDelete: Cascade)
  resume Resume? @relation(fields: [resumeId], references: [id], onDelete: SetNull)

  @@index([userId])
  @@index([userId, status])
  @@map("jobs")
}

enum JobStatus {
  saved
  applied
  interview
  offer
  rejected
}

model Resume {
  id        String   @id @default(uuid()) @db.Uuid
  userId    String   @db.Uuid
  fileName  String   @db.VarChar(255)
  filePath  String   @db.VarChar(500)
  fileSize  Int
  mimeType  String   @db.VarChar(50)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  jobs Job[]

  @@index([userId])
  @@map("resumes")
}
```

### 7.3 Key Indexes & Constraints

| Index | Type | Columns | Purpose |
|-------|------|---------|---------|
| `jobs_user_id_idx` | B-tree | `userId` | Fast lookup of all jobs for a user |
| `jobs_user_status_idx` | Composite B-tree | `userId, status` | Filter by status (dashboard stats) |
| `jobs_user_created_idx` | Composite B-tree | `userId, createdAt DESC` | Recent jobs sorting |
| `resumes_user_id_idx` | B-tree | `userId` | Fast lookup of user's resumes |
| `users_email_unique` | Unique | `email` | Enforce unique email addresses |

### 7.4 Migration Strategy

- All schema changes are managed via Prisma Migrate
- Migrations are checked into version control
- Development: `npx prisma migrate dev` (auto-applies + generates client)
- Production: `npx prisma migrate deploy` (applies pending migrations only)
- Seed script: `prisma/seed.js` for development data

```json
// package.json scripts
{
  "scripts": {
    "db:migrate:dev": "prisma migrate dev",
    "db:migrate:deploy": "prisma migrate deploy",
    "db:generate": "prisma generate",
    "db:seed": "prisma db seed",
    "db:studio": "prisma studio",
    "db:reset": "prisma migrate reset"
  }
}
```

---

## 8. Error Handling Strategy

### 8.1 Error Handling Philosophy

JobPilot AI uses a **functional error handling** approach on the frontend and a **centralized error handler** on the backend. The goal is that no unhandled exception ever reaches the user without being converted into a meaningful message.

### 8.2 Frontend Error Handling

#### Failure Hierarchy (Domain Layer)

```
Failure (sealed class)
├── ServerFailure       (HTTP 5xx, network errors)
│   ├── InternalFailure (500)
│   └── ServiceUnavailable (503)
├── AuthFailure         (HTTP 401, 403)
│   ├── UnauthorizedFailure (401)
│   └── ForbiddenFailure (403)
├── ValidationFailure   (HTTP 400, 422)
│   ├── BadRequestFailure (400)
│   └── BusinessRuleFailure (422)
├── NotFoundFailure     (HTTP 404)
├── ConflictFailure     (HTTP 409)
├── CacheFailure        (local data error)
├── FileFailure         (upload/download issues)
│   ├── FileTooLargeFailure
│   └── InvalidFileTypeFailure
└── UnexpectedFailure   (catch-all)
```

```dart
// core/error/failures.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.server(String message) = ServerFailure;
  const factory Failure.auth(String message) = AuthFailure;
  const factory Failure.validation(String message) = ValidationFailure;
  const factory Failure.notFound(String message) = NotFoundFailure;
  const factory Failure.conflict(String message) = ConflictFailure;
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.file(String message) = FileFailure;
  const factory Failure.unexpected(String message) = UnexpectedFailure;
}
```

#### Exception → Failure Mapping (Data Layer)

```dart
// core/error/exception_mapper.dart
extension ExceptionMapper on Exception {
  Failure toFailure() {
    switch (this) {
      case DioException e:
        return _mapDioException(e);
      case CacheException e:
        return Failure.cache(e.message);
      default:
        return Failure.unexpected(toString());
    }
  }

  Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Failure.server('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return Failure.server('No internet connection.');
      case DioExceptionType.badResponse:
        return _mapStatusCode(e.response?.statusCode, e.response?.data);
      default:
        return Failure.unexpected('An unexpected error occurred.');
    }
  }

  Failure _mapStatusCode(int? statusCode, dynamic data) {
    final message = data?['message'] ?? 'An error occurred';
    switch (statusCode) {
      case 400: return Failure.validation(message);
      case 401: return Failure.auth('Session expired. Please login again.');
      case 403: return Failure.auth('You do not have permission.');
      case 404: return Failure.notFound(message);
      case 409: return Failure.conflict(message);
      case 422: return Failure.validation(message);
      case 413: return Failure.file('File is too large.');
      case 429: return Failure.server('Too many requests. Please wait.');
      case >= 500: return Failure.server(message);
      default: return Failure.unexpected(message);
    }
  }
}
```

#### BLoC Error Handling Pattern

```dart
class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobsUsecase getJobs;

  JobBloc({required this.getJobs}) : super(JobInitial()) {
    on<LoadJobsEvent>(_onLoadJobs);
  }

  Future<void> _onLoadJobs(LoadJobsEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    final result = await getJobs.call();

    result.fold(
      (failure) {
        // Map Failure → user-friendly UI state
        if (failure is AuthFailure) {
          // AuthBloc should handle re-login
          emit(JobAuthRequired());
        } else {
          emit(JobError(_userFriendlyMessage(failure)));
        }
      },
      (jobs) => emit(JobsLoaded(jobs)),
    );
  }

  String _userFriendlyMessage(Failure failure) {
    return switch (failure) {
      ServerFailure() => 'Server error. Please try again later.',
      AuthFailure() => 'Please login again.',
      NotFoundFailure() => 'Job not found. It may have been deleted.',
      _ => failure.message,
    };
  }
}
```

### 8.3 Backend Error Handling

#### Custom Error Class

```javascript
// utils/ApiError.js
class ApiError extends Error {
  constructor(statusCode, message, errors = null) {
    super(message);
    this.statusCode = statusCode;
    this.errors = errors;
    this.isOperational = true; // Distinguishes expected vs unexpected errors

    Error.captureStackTrace(this, this.constructor);
  }

  static badRequest(message, errors) {
    return new ApiError(400, message, errors);
  }

  static unauthorized(message = 'Authentication required') {
    return new ApiError(401, message);
  }

  static forbidden(message = 'Forbidden') {
    return new ApiError(403, message);
  }

  static notFound(message = 'Resource not found') {
    return new ApiError(404, message);
  }

  static conflict(message) {
    return new ApiError(409, message);
  }

  static unprocessable(message) {
    return new ApiError(422, message);
  }
}

module.exports = ApiError;
```

#### Global Error Handler Middleware

```javascript
// middleware/error.middleware.js
const logger = require('../utils/logger');

module.exports = (err, req, res, next) => {
  // Log everything
  logger.error({
    message: err.message,
    stack: err.stack,
    url: req.originalUrl,
    method: req.method,
    userId: req.user?.id,
  });

  // Prisma known request errors
  if (err.code === 'P2002') {
    return res.status(409).json({
      success: false,
      message: 'A record with this value already exists.',
    });
  }

  if (err.code === 'P2025') {
    return res.status(404).json({
      success: false,
      message: 'The requested record was not found.',
    });
  }

  // Multer file size error
  if (err.code === 'LIMIT_FILE_SIZE') {
    return res.status(413).json({
      success: false,
      message: 'File size exceeds the 5MB limit.',
    });
  }

  // Our known operational errors
  if (err.isOperational) {
    return res.status(err.statusCode).json({
      success: false,
      message: err.message,
      ...(err.errors && { errors: err.errors }),
    });
  }

  // Unknown errors — don't leak details in production
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    message: process.env.NODE_ENV === 'production'
      ? 'Internal server error'
      : err.message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};
```

#### Async Handler Wrapper

```javascript
// utils/asyncHandler.js
// Wraps async route handlers to catch rejected promises
// without needing try/catch in every controller method
module.exports = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};
```

### 8.4 Error Handling Flow — Complete Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   ERROR HANDLING — FULL FLOW                            │
│                                                                         │
│  FRONTEND                       BACKEND                                │
│                                                                         │
│  ┌──────────────┐              ┌──────────────────────────────────────┐│
│  │ User Action  │─────────────▶│  Express Route                       ││
│  └──────────────┘              │  (e.g., POST /api/jobs)              ││
│                                └────────────────┬─────────────────────┘│
│                                                 │                      │
│  ┌──────────────┐                               ▼                      │
│  │ BLoC Event   │              ┌──────────────────────────────────────┐│
│  │ dispatched   │              │  Auth Middleware                     ││
│  └──────┬───────┘              │  • Missing token → throw ApiError(401)│
│         │                      │  • Invalid token → throw ApiError(401)│
│         ▼                      │  • Valid → req.user = decoded        ││
│  ┌──────────────┐              └────────────────┬─────────────────────┘│
│  │ UseCase.call │                               │                      │
│  └──────┬───────┘                               ▼                      │
│         │                      ┌──────────────────────────────────────┐│
│         ▼                      │  Validation Middleware               ││
│  ┌──────────────┐              │  • Joi schema validation             ││
│  │ Repository   │              │  • Invalid → throw ApiError(400)     ││
│  │ .method()    │              └────────────────┬─────────────────────┘│
│  └──────┬───────┘                               │                      │
│         │                      ┌─────────────────▼────────────────────┐│
│         ▼                      │  Controller                         ││
│  ┌──────────────┐              │  • Parses req.params, body          ││
│  │ DataSource   │─────────────▶│  • Calls service                    ││
│  │ .apiCall()   │  HTTP Error  └────────────────┬─────────────────────┘│
│  └──────┬───────┘                               │                      │
│         │                      ┌─────────────────▼────────────────────┐│
│         ▼                      │  Service                            ││
│  ┌──────────────────────┐      │  • Business logic                   ││
│  │  DioException caught │      │  • Throws ApiError on rule violation││
│  │  by ErrorInterceptor │      │  • Prisma query                     ││
│  └──────────┬───────────┘      └────────────────┬─────────────────────┘│
│             │                                   │                      │
│             ▼                                   ▼                      │
│  ┌──────────────────────┐      ┌──────────────────────────────────────┐│
│  │ Exception → Failure  │      │  Error caught by asyncHandler        ││
│  │ mapping (data layer) │◀─────│  → passed to next(err)               ││
│  └──────────┬───────────┘      └────────────────┬─────────────────────┘│
│             │                                   │                      │
│             ▼                                   ▼                      │
│  ┌──────────────────────┐      ┌──────────────────────────────────────┐│
│  │ Either<Failure, T>   │      │  Global Error Handler Middleware     ││
│  │ returned to BLoC     │      │  • Logs error                        ││
│  └──────────┬───────────┘      │  • Maps to standardized response    ││
│             │                   │  • Returns JSON error envelope      ││
│             ▼                   └──────────────────────────────────────┘│
│  ┌──────────────────────┐                                               │
│  │ BLoC emits error     │                                               │
│  │ state                │                                               │
│  └──────────┬───────────┘                                               │
│             │                                                           │
│             ▼                                                           │
│  ┌──────────────────────┐                                               │
│  │ UI shows SnackBar /  │                                               │
│  │ ErrorBanner /        │                                               │
│  │ Retry button         │                                               │
│  └──────────────────────┘                                               │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 9. State Management Design

### 9.1 BLoC Architecture — Detailed

Each feature BLoC follows a consistent lifecycle:

```
┌──────────────────────────────────────────────────────────────────┐
│                    BLOC LIFECYCLE                                │
│                                                                  │
│  1. CREATION                                                    │
│     ┌───────────────────┐                                       │
│     │ BlocProvider      │  Injected via getIt<JobBloc>()       │
│     │ .value(bloc)      │  or created lazily                    │
│     └───────────────────┘                                       │
│                                                                  │
│  2. EVENT DISPATCH                                              │
│     ┌───────────────────┐                                       │
│     │ context           │  BlocProvider.of<JobBloc>(context)    │
│     │ .read<JobBloc>()  │  .add(LoadJobsEvent())               │
│     │ .add(event)       │                                       │
│     └───────────────────┘                                       │
│                                                                  │
│  3. PROCESSING                                                  │
│     ┌───────────────────┐  on<LoadJobsEvent>((event, emit) {   │
│     │ mapEventToState   │    emit(JobLoading());               │
│     │ (async generator) │    final result = await useCase();    │
│     └───────────────────┘    emit(result.fold(                  │
│                                (f) => JobError(f),             │
│                                (d) => JobsLoaded(d),           │
│                              ));                                │
│                            });                                  │
│                                                                  │
│  4. STATE EMISSION                                              │
│     ┌───────────────────┐  State changes trigger UI rebuilds   │
│     │ emit(newState)    │  via BlocBuilder / BlocListener       │
│     └───────────────────┘                                       │
│                                                                  │
│  5. DISPOSAL                                                    │
│     ┌───────────────────┐  Auto-closed when route is popped     │
│     │ bloc.close()      │  (close() cancels all subscriptions)  │
│     └───────────────────┘                                       │
└──────────────────────────────────────────────────────────────────┘
```

### 9.2 State Design Principles

Every BLoC state is an immutable Freezed union:

```dart
@freezed
sealed class JobState with _$JobState {
  // Initial state before any event
  const factory JobState.initial() = JobInitial;

  // Loading state (spinner/skeleton shown)
  const factory JobState.loading() = JobLoading;

  // Success states (data available)
  const factory JobState.loaded(List<Job> jobs) = JobsLoaded;
  const factory JobState.created(Job job) = JobCreated;
  const factory JobState.updated(Job job) = JobUpdated;
  const factory JobState.deleted(String id) = JobDeleted;

  // Special auth state (redirect to login)
  const factory JobState.authRequired() = JobAuthRequired;

  // Error state with user-friendly message
  const factory JobState.error(String message) = JobError;
}
```

### 9.3 BLoC Event Categories

| Event Category | Example | Behavior |
|----------------|---------|----------|
| **Load** | `LoadJobsEvent` | Fetches data, loading → loaded or error |
| **Create** | `CreateJobEvent(data)` | Creates resource, loading → created or error |
| **Update** | `UpdateJobEvent(id, data)` | Updates resource, loading → updated or error |
| **Delete** | `DeleteJobEvent(id)` | Deletes resource, loading → deleted or error |
| **Refresh** | `RefreshJobsEvent` | Re-fetches current data (pull-to-refresh) |
| **Filter** | `FilterJobsEvent(status)` | Changes filter, reloads list |

### 9.4 Cross-Bloc Communication

BLoCs communicate through events, not direct references:

```
┌──────────────┐  Auth token expires   ┌──────────────┐
│  JobBloc     │───────────────────────▶│  AuthBloc    │
│  (API call)  │  (emits JobAuthReq.)   │             │
│              │                        │  → shows     │
│              │                        │  re-login    │
│              │                        │  dialog      │
└──────────────┘                        └──────────────┘

┌──────────────┐  Job created/deleted  ┌──────────────┐
│  JobBloc     │───────────────────────▶│ DashboardBC  │
│  (CRUD)      │  DashboardBloc        │  (refresh    │
│              │  listens to JobBloc   │  stats)      │
│              │  state changes         │              │
└──────────────┘                        └──────────────┘
```

This is achieved via `BlocListener` at the app level:

```dart
// In AppShell or DashboardPage
BlocListener<JobBloc, JobState>(
  listener: (context, state) {
    if (state is JobCreated || state is JobDeleted || state is JobUpdated) {
      // Refresh dashboard stats without coupling BLoCs
      context.read<DashboardBloc>().add(RefreshDashboardEvent());
    }
  },
);
```

### 9.5 Complete State Transition Map — Job Feature

```
                    ┌──────────┐
                    │  Initial │
                    └────┬─────┘
                         │
                         │ LoadJobsEvent
                         ▼
                    ┌──────────┐
              ┌────▶│ Loading  │◀────────────────────┐
              │     └────┬─────┘                      │
              │          │                            │
              │    ┌─────┴────────┐                   │
              │    ▼              ▼                   │
              │ ┌────────┐  ┌─────────┐              │
              │ │ Loaded │  │  Error  │── Refresh ────┘
              │ └───┬────┘  └─────────┘
              │     │
              │     ├── CreateJobEvent   → Loading → Created → Loaded
              │     ├── UpdateJobEvent   → Loading → Updated → Loaded
              │     ├── DeleteJobEvent   → Loading → Deleted → Loaded
              │     └── FilterJobsEvent  → Loading → Loaded (filtered)
              │
              └───── RefreshJobsEvent
```

---

## 10. File Upload Design

### 10.1 Upload Constraints

| Constraint | Value | Enforcement |
|-----------|-------|-------------|
| Max file size | 5 MB | Multer (server) + Dart validation (client) |
| Allowed types | PDF, DOC, DOCX | File extension + MIME type check |
| Max files per user | 10 | Service layer check before DB insert |
| Storage location | `uploads/` directory | Docker volume for persistence |
| File naming | `{timestamp}-{uuid}.{ext}` | Prevents collisions |

### 10.2 Upload Security

- Files are stored outside the `src/` directory (not served statically by default)
- Downloads require authentication + authorization
- File type is validated by both frontend (mime type) and backend (extension + magic bytes via `file-type` package)
- Upload directory is excluded from version control (`.gitignore`)
- Production: files stored on S3-compatible storage (planned)

### 10.3 Frontend Upload Implementation

```dart
class ResumeRemoteDataSource {
  final Dio dio;

  Future<ResumeModel> uploadResume(File file) async {
    final formData = FormData.fromMap({
      'resume': await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      ),
    });

    final response = await dio.post(
      '/api/resumes/upload',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        onSendProgress: (sent, total) {
          // Emit upload progress to BLoC for progress bar
          final progress = sent / total;
        },
      ),
    );

    return ResumeModel.fromJson(response.data['data']);
  }
}
```

---

## 11. Security Design

### 11.1 Security Layers

```
┌──────────────────────────────────────────────────────────────┐
│                      SECURITY LAYERS                         │
│                                                              │
│  LAYER 1: TRANSPORT                                         │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ HTTPS (TLS 1.3)                                        │ │
│  │ • All API traffic encrypted in transit                 │ │
│  │ • Certificates managed by Let's Encrypt / Cloudflare   │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  LAYER 2: AUTHENTICATION                                    │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ JWT (JSON Web Tokens)                                  │ │
│  │ • Access token: 15 min expiry                          │ │
│  │ • Refresh token: 7 day expiry                          │ │
│  │ • Stored in flutter_secure_storage (Keychain/Keystore) │ │
│  │ • HTTPS-only, no cookie-based session                  │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  LAYER 3: AUTHORIZATION                                     │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Role & Ownership Checks                                │ │
│  │ • All resources scoped to authenticated user           │ │
│  │ • Service layer verifies ownership before mutations    │ │
│  │ • userId always extracted from JWT, never from request │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  LAYER 4: INPUT VALIDATION                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Defense in Depth                                       │ │
│  │ • Client: form validation before API call              │ │
│  │ • Transport: Joi schema validation on every request    │ │
│  │ • Database: Prisma type checking + parameterized SQL   │ │
│  │ • XSS prevention: never render raw HTML                │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  LAYER 5: DATA PROTECTION                                   │
│  ┌────────────────────────────────────────────────────────┐ │
│  • Passwords: bcrypt (cost factor 12)                     │ │
│  • No sensitive data in JWT payload (only id, email)      │ │
│  • File upload validation (type, size, magic bytes)       │ │
│  • Environment variables for secrets (never in code)      │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

### 11.2 Password Policy

| Requirement | Value |
|------------|-------|
| Min length | 8 characters |
| Max length | 128 characters |
| Complexity | At least 1 uppercase, 1 lowercase, 1 number |
| Hashing | bcrypt with cost factor 12 |
| Storage | `passwordHash` field only, raw password never persisted |

---

*This system design document is a living specification. Update it whenever API contracts change, new flows are added, or infrastructure decisions are made.*
