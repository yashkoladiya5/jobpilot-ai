# JobPilot AI — Learning Journal

> **Purpose:** A developer's guide to every major concept in the project.  
> **Target Audience:** Flutter developer (3+ yrs) learning full-stack/backend.  
> **Last Updated:** June 2026

---

## Table of Contents

1. [Clean Architecture](#concept-clean-architecture)
2. [BLoC Pattern](#concept-bloc-pattern)
3. [JWT Authentication](#concept-jwt-authentication)
4. [Layered Backend Architecture](#concept-layered-backend-architecture)
5. [ORM vs Raw SQL](#concept-orm-vs-raw-sql)
6. [Repository Pattern](#concept-repository-pattern)
7. [Dependency Injection](#concept-dependency-injection)
8. [Immutable State](#concept-immutable-state)
9. [Middleware Pattern](#concept-middleware-pattern)
10. [Docker Containers](#concept-docker-containers)
11. [Environment Variables](#concept-environment-variables)
12. [RESTful API Design](#concept-restful-api-design)

---

## Concept: Clean Architecture

**Why It Exists:**
Software projects die from coupling. When UI code directly calls databases, changing either one breaks everything. Clean Architecture solves this by enforcing a **dependency rule**: dependencies only point inward. The innermost layer (Domain) knows nothing about Flutter, Dio, or databases. It contains pure business logic. The outer layers (Data, Presentation) implement interfaces defined by the inner layer. This means you can swap your HTTP client, database, or UI framework without touching business logic. In JobPilot, the `GetJobsUsecase` doesn't import Flutter or Dio — it only depends on `JobRepository` (an abstract interface). That one decision makes the use case instantly testable, framework-independent, and resistant to technology churn.

**When To Use:**
- Multi-feature apps that will live for 12+ months
- Projects where business logic is complex enough to justify separation
- Teams that practice unit testing (Clean Architecture makes mocking trivial)
- Any app that might need to change data sources (swap REST for GraphQL, add offline cache)

**When Not To Use:**
- Prototypes, MVPs, or hackathon projects (the boilerplate slows initial velocity)
- Apps with trivial business logic (a calculator doesn't need use cases)
- Single-developer projects where you personally value speed over structure
- Situations where the team isn't bought in — Clean Architecture requires discipline; half-hearted adoption gives you the worst of both worlds (boilerplate without benefits)

**Common Interview Question:**
*"Explain the dependency rule in Clean Architecture. Why is it important?"*

The dependency rule states that source code dependencies can only point inward — toward the Domain layer. The Domain layer defines interfaces (abstract classes) and entities. The Data layer implements those interfaces. The Presentation layer depends on the Domain layer via use cases. This is important because it inverts control: outer layers (which deal with frameworks, databases, and UI) depend on inner layers (which contain pure business rules). This makes the Domain layer testable without any framework, allows swapping implementations (e.g., switching from Dio to http package) without changing business logic, and prevents framework lock-in. In this project, if we switch from REST to GraphQL, we create a new `JobRemoteDataSource` and implement the same `JobRepository` interface — the Domain and Presentation layers never change.

**Real World Example:**
In 2023, a major fintech app needed to migrate from REST to GraphQL to reduce mobile data usage. Because they followed Clean Architecture, the migration required zero changes to business logic or UI. The team created new DataSource classes implementing existing repository interfaces. The migration took 2 weeks instead of the estimated 3 months. Without Clean Architecture, the GraphQL queries would have been scattered across widgets and controllers, requiring a full rewrite.

---

## Concept: BLoC Pattern

**Why It Exists:**
Flutter widgets rebuild when state changes. Without a pattern, developers scatter `setState` calls, business logic leaks into widgets, and state mutations become impossible to track. BLoC (Business Logic Component) enforces **unidirectional data flow**: UI dispatches Events → BLoC processes them → BLoC emits new States → UI rebuilds. There is no way for a widget to directly mutate state. Every state change is predictable, traceable, and testable. BLoC also scopes state to features — navigating away disposes the BLoC, freeing memory. When you tap "Save" on CreateJobPage, the page dispatches a `CreateJobEvent`. The `JobBloc` receives it, calls the use case, and emits either `JobCreated` or `JobError`. The UI subscribes to these states via `BlocBuilder` and reacts accordingly. No widget ever calls `setState` or directly modifies job data.

**When To Use:**
- Any Flutter app with more than 3 screens
- Apps that need comprehensive unit testing (blocTest is the best testing experience in Flutter)
- Teams that value strict patterns over rapid prototyping
- Features with complex state (loading, empty, error, success, pagination)

**When Not To Use:**
- Simple UI with local state only (a switch toggle doesn't need a BLoC — use `StatefulWidget`)
- Prototypes where speed is the only priority
- Situations where the team can't commit to the three-file pattern (event, state, bloc)

**Common Interview Question:**
*"What is the difference between BLoC and Cubit? When would you use one over the other?"*

A Cubit is a simplified BLoC that uses functions instead of events. Instead of dispatching a `LoginEvent`, you call `cubit.login(email, password)`. Cubit emits states directly from method calls. BLoC is more formal: you define event classes and the BLoC maps events to states via `on<Event>((event, emit) => ...)`. Use Cubit for simple features where the extra event class adds ceremony without value (e.g., a counter, a toggle). Use BLoC when you need event tracing, replay, or when events carry rich data (like form submissions). In this project, we use BLoC exclusively for consistency, but a Cubit could work for the theme toggle or bottom navigation index.

**Real World Example:**
Google Pay uses BLoC for transaction processing. When a user sends money, the UI dispatches a `SendMoneyEvent` with amount and recipient. The BLoC validates, calls the API, and emits `SendMoneyLoading` (UI shows spinner), `SendMoneySuccess` (UI shows confirmation), or `SendMoneyError` (UI shows error with retry). Every state transition is logged for debugging. If a transaction fails mid-flight, the BLoC can replay events for retry without user re-entering data.

---

## Concept: JWT Authentication

**Why It Exists:**
HTTP is stateless — each request is independent. To identify users across requests, you need an authentication mechanism. JWTs (JSON Web Tokens) are self-contained tokens: they encode user identity (id, email) plus metadata (issued at, expiry) in a cryptographically signed JSON payload. The server never needs to query a database to verify a user — it just validates the signature. This makes JWTs **stateless**: you can scale your API to 100 servers and any server can verify any token without a shared session store. The tradeoff is that JWTs cannot be revoked before expiry (unless you maintain a blocklist, which defeats statelessness). In this project, we mitigate this with a **two-token strategy**: short-lived access tokens (15 minutes) plus longer-lived refresh tokens (7 days) stored in the database with revocation support.

**When To Use:**
- Mobile apps (no cookie store, no CSRF concerns)
- Microservices (a single token works across services with the same secret/public key)
- Stateless APIs that need horizontal scaling
- Any scenario where you don't want server-side session storage

**When Not To Use:**
- Server-rendered web apps (session cookies are simpler and more secure for traditional web)
- Apps requiring instant user revocation (JWTs have a natural delay until expiry)
- High-security scenarios where token theft is a primary threat (consider OAuth 2.0 with PKCE + refresh token rotation + biometric binding)
- Internal APIs on a trusted network (simple API keys are sufficient)

**Common Interview Question:**
*"How do you handle token refresh without making the UX feel broken?"*

The key is transparent interception at the HTTP client layer. In this project, Dio's `AuthInterceptor` catches 401 responses, checks if there's a refresh token in secure storage, calls `/api/auth/refresh`, stores the new tokens, and retries the original request — all without the UI or BLoC knowing anything happened. The user never sees a "session expired" dialog. If the refresh also fails (refresh token expired or revoked), the interceptor emits a logout event that navigates to the login screen. This pattern is called "token refresh interceptor" and is standard in production apps. On the backend, refresh tokens are one-time-use (rotation): each refresh endpoint call invalidates the old refresh token and issues a new one, preventing replay attacks.

**Real World Example:**
The Spotify mobile app uses JWT with refresh token rotation. When you log in, you get a short-lived access token (~1 hour) and a long-lived refresh token. The mobile client stores both in the platform keychain. When the access token expires, the API client transparently refreshes it. Spotify can revoke a session by deleting the refresh token from their database — the user stays logged in only until the current access token expires. This is why revoking a Spotify session from the web takes up to an hour to take effect on mobile.

---

## Concept: Layered Backend Architecture

**Why It Exists:**
Express.js is unopinionated — you can write an entire API in a single file. That works for 5 routes but becomes unmanageable at 50+. Layered Architecture enforces discipline by dividing the server into distinct layers, each with a single responsibility. Routes define endpoints. Middleware handles cross-cutting concerns (auth, validation, error handling, file uploads). Controllers parse HTTP requests and format responses. Services contain business logic. The ORM/Prisma layer handles database communication. The rule: a layer can only call the layer directly below it. A controller calls a service but never calls Prisma directly. A service never reads `req.headers`. This separation means you can test services without HTTP, swap Prisma for another ORM without changing controllers, and add new features without modifying existing route definitions.

**When To Use:**
- Any Express API with more than 10 endpoints
- Projects where multiple developers work on the same codebase
- APIs that need unit testing (services are testable without HTTP)
- Long-lived projects that will be maintained for years

**When Not To Use:**
- Simple APIs with 3-5 endpoints (a single file with inline logic is faster)
- Serverless functions where each function is already isolated (Lambda handlers are inherently layered)
- Prototypes where you're validating an idea, not building for production
- Scripts and internal tools (layering is overhead for a cron job)

**Common Interview Question:**
*"What's the difference between a Controller and a Service? Why separate them?"*

A Controller handles HTTP concerns: parsing `req.params`, `req.query`, `req.body`, setting status codes, and formatting the response. A Service handles business logic: validation rules, database queries, file processing, and calculations. They are separate because they change for different reasons — controllers change when the API contract changes (new fields, different status codes), services change when business rules change (new application limit, different status transitions). Separating them also enables testing services without HTTP (pure function testing) and reusing services across different controllers (e.g., an admin controller and a user controller calling the same service with different permissions).

**Real World Example:**
Stripe's API is a masterclass in layered architecture. Their controllers handle HTTP (rate limiting, idempotency keys, pagination cursors), while services handle business logic (charge calculation, fraud detection, balance updates). When Stripe adds a new API version, they sometimes add a new controller layer (for request/response transformation) while reusing the same services. This is why Stripe can support API versioning without duplicating business logic.

---

## Concept: ORM vs Raw SQL

**Why It Exists:**
Databases speak SQL. Your application code speaks JavaScript/Dart. An ORM (Object-Relational Mapper) bridges this gap by letting you write database queries in your programming language: `prisma.job.findMany({ where: { status: 'applied' } })` instead of `SELECT * FROM jobs WHERE status = 'applied'`. ORMs provide type safety, migration management, relationship loading, and protection against SQL injection. But they add an abstraction layer — complex queries can be harder to optimize, and the generated SQL may not use indexes efficiently. Raw SQL gives you full control and maximum performance but sacrifices developer experience and portability. The pragmatic approach: use an ORM for 80% of queries (CRUD, simple filters) and raw SQL for the 20% that need optimization (complex reports, bulk operations, recursive CTEs).

**When To Use ORM:**
- Standard CRUD operations
- Apps with clear, well-defined data models
- Teams that value developer velocity and type safety
- Projects with frequent schema changes (automatic migration generation)
- Small to medium datasets where query performance isn't the bottleneck

**When To Use Raw SQL:**
- Complex reporting queries with multiple aggregations
- Full-text search with custom ranking
- Bulk updates/inserts on large datasets
- Queries needing database-specific features (PostgreSQL `ON CONFLICT`, `RETURNING`, window functions)
- Performance-critical paths where every millisecond matters

**Common Interview Question:**
*"What is the N+1 problem in ORMs and how do you solve it?"*

The N+1 problem occurs when an ORM fetches a list of parent records and then executes a separate query for each parent's children. For example, fetching 100 jobs and their resumes: the ORM runs 1 query to get jobs, then 100 queries to get each job's resume — that's N+1 = 101 queries. Prisma solves this with `include` and `select` options that generate a single SQL `JOIN` query. In this project, `prisma.job.findMany({ include: { resume: true } })` generates one query with a LEFT JOIN. The rule: always inspect generated queries during development (Prisma's `log: ['query']` option shows every SQL statement) and eagerly load relationships when you know you'll need them.

**Real World Example:**
Airbnb's early infrastructure used Rails/ActiveRecord (an ORM). As they scaled, they hit N+1 problems on search pages — loading 50 listings triggered 50+ queries for photos and reviews. They solved it by adding `includes(:photos, :reviews)` to eagerly load relationships. Later, they migrated the most critical search queries to raw SQL for performance. This is the typical evolution: ORM for velocity → raw SQL for optimization at scale. In this project, Prisma handles 95% of queries; if the dashboard performance becomes an issue, the stats aggregation query would be the first candidate for raw SQL.

---

## Concept: Repository Pattern

**Why It Exists:**
Without a repository, every BLoC or use case that needs data must know about DataSources, Dio, JSON serialization, and error handling. This creates coupling — changing how data is fetched (e.g., adding caching) means touching every use case. The Repository pattern introduces an **abstraction** (an interface/abstract class) between business logic and data sources. The Domain layer defines: `abstract class JobRepository { Future<Either<Failure, List<Job>>> getJobs(); }`. The Data layer implements it: `class JobRepositoryImpl implements JobRepository`. The BLoC only depends on `JobRepository` (the abstraction). This means you can add caching, switch APIs, or swap databases by changing only the implementation — the BLoC never changes. It also makes testing trivial: you mock `JobRepository` in BLoC tests without setting up Dio or a database.

**When To Use:**
- Clean Architecture or any layered architecture
- Apps with multiple data sources (remote API + local cache)
- Any project that uses dependency injection
- Features where data access logic is complex enough to justify abstraction

**When Not To Use:**
- Simple apps where each BLoC directly calls a single API (the abstraction adds indirection without benefit)
- Scripts or tools where there's no dependency injection
- Features that do only one data operation (justification depends on overall architecture)

**Common Interview Question:**
*"How is the Repository pattern different from the Data Access Object (DAO) pattern?"*

A DAO is a lower-level abstraction — it typically maps to a single table or data source and exposes CRUD operations directly. A Repository is a higher-level abstraction — it can aggregate multiple DAOs or data sources, apply business rules, and return domain objects. In this project, `JobRemoteDataSource` is closer to a DAO (it maps to the `/api/jobs` endpoint and returns `JobModel`), while `JobRepositoryImpl` is a Repository (it coordinates between remote and local data sources, maps `Model` to `Entity`, and handles errors). Think of it this way: DAOs deal with data formats (JSON, SQL rows), Repositories deal with business objects (Entities). The Repository wraps the DAO(s) and translates between the two worlds.

**Real World Example:**
The Twitter/FediLabs Android app uses the Repository pattern extensively. Their `TweetRepository` interface defines methods like `getTimeline()`, `postTweet()`, and `likeTweet()`. The implementation coordinates between a remote API data source and a local Room database (SQLite). When the network is available, data comes from the API and is cached locally. When offline, the repository serves cached data. The ViewModel (their equivalent of BLoC) depends only on `TweetRepository` and never knows about Retrofit, Room, or network state. This allowed them to rewrite their networking layer from OkHttp to Ktor without touching any ViewModel.

---

## Concept: Dependency Injection

**Why It Exists:**
When a class creates its own dependencies (e.g., `JobBloc` calls `JobRepositoryImpl()` directly), it becomes coupled to concrete implementations. You cannot test the BLoC without also testing the repository, the data source, Dio, and the database. Dependency Injection (DI) inverts this: **dependencies are provided to a class from the outside**, typically through constructor parameters. `JobBloc({required JobRepository jobRepository})`. The BLoC doesn't know or care what `jobRepository` actually is — it could be a real implementation, a mock, or a fake. DI enables testing, reduces coupling, and makes dependency graphs explicit. In this project, we use `injectable` to auto-generate DI wiring — annotations like `@injectable` on `JobBloc` tell the code generator to register it in the `GetIt` service locator and resolve its constructor dependencies automatically.

**When To Use:**
- Clean Architecture projects (layers must be decoupled)
- Apps where you write unit tests (mocking requires DI)
- Projects that grow beyond 5-6 classes (manual wiring becomes error-prone)
- Teams that practice SOLID principles (DI is essential for Dependency Inversion)

**When Not To Use:**
- Tiny projects with 2-3 classes (manual instantiation is fine)
- Performance-critical startup paths (service locator lookups have microseconds of overhead)
- Scripts and tools (DI adds unnecessary complexity)

**Common Interview Question:**
*"What is the difference between a Service Locator and Dependency Injection? Why did we choose GetIt (service locator)?"*

A Service Locator (like GetIt) is a registry where you ask for dependencies: `GetIt.I.get<JobRepository>()`. Dependency Injection (like Dagger, Hilt, or Injectable-generated code) provides dependencies through constructors. Service locators are sometimes called "DI containers" but they're technically a different pattern. In this project, we use `get_it` as the service locator and `injectable` to generate the registration code. The key difference: with DI, dependencies are explicit in constructors (you can see them in the type signature). With a service locator, dependencies are implicit — a class can call `GetIt.I.get()` anywhere, making it harder to understand what a class needs without reading its entire code. We accept this tradeoff because Injectable generates the wiring for us, keeping it centralized in one config file, and the constructor injection pattern is still used within classes — only the top-level registration uses the locator.

**Real World Example:**
The Google IO 2024 mobile app uses Hilt (Dagger for Android) for DI. Their `CheckInViewModel` receives `CheckInRepository`, `LocationService`, and `NotificationManager` via constructor injection. When they wrote unit tests, they passed mock implementations of all three dependencies — zero setup beyond the mock objects. The same app using a service locator without DI would have required mocking a global registry. The lesson: DI isn't about the tool (Dagger, Hilt, GetIt) — it's about the pattern of providing dependencies from outside rather than creating them internally.

---

## Concept: Immutable State

**Why It Exists:**
Mutable state is the #1 source of bugs in UI applications. If two widgets can modify the same state object simultaneously, you get unpredictable UI, stale data, and hard-to-reproduce crashes. Immutable state means **state objects never change after creation**. Instead of modifying an existing object, you create a new copy with the changed values. Freezed generates `copyWith` for this: `state.copyWith(name: 'newName')`. This guarantees that any widget holding a reference to the old state will never see it change unexpectedly. It also enables referential equality checks — `BlocBuilder` can check `if (previousState == newState)` to skip unnecessary rebuilds. With mutable state, two different "same" states might have different object references, causing wasteful rebuilds.

**When To Use:**
- Any state management pattern (BLoC, Riverpod, Redux all assume immutable state)
- Multi-widget screens where state is shared
- Features with lists (immutability prevents accidental mutation of list items)
- Concurrent/async code (immutability eliminates race conditions on shared state)

**When Not To Use:**
- Local widget state that's never shared (a single `bool` in a `StatefulWidget`)
- Performance-critical code where creating new objects is too expensive (profile first — this is rarely the bottleneck)
- Prototypes (you want speed, not correctness)

**Common Interview Question:**
*"How does Freezed's generated code differ from manually writing copyWith? What's the performance impact?"*

Freezed generates a `copyWith` that returns a new instance with the specified fields changed. For a `User` class with 5 fields, the generated `copyWith` creates one new object and copies 5 field values — nanoseconds of work. Manually you'd write the same thing, but with a higher chance of bugs (forgetting to copy a field introduces a bug where that field reverts to default). The performance impact of immutable state is negligible in practice — creating objects is extremely cheap in Dart. If you're creating thousands of objects per frame (you shouldn't be), the concern is GC pressure, not object creation cost. The real performance win from immutability comes from `==` operator overrides that enable Flutter to avoid rebuilding widgets when state hasn't meaningfully changed.

**Real World Example:**
The Flutter framework itself is immutable — every `RenderObject` and `Element` uses immutability for its configuration. When you call `Text('hello')`, you're not modifying the old Text widget — you're creating a new one. Flutter diffs the old and new widget trees and only updates what changed. This is the same principle as Freezed's immutable state: creating new objects and comparing them efficiently. The Flutter team bet the entire framework on immutability being fast enough, and it works for 60fps UI. Your state objects are small by comparison.

---

## Concept: Middleware Pattern

**Why It Exists:**
Every HTTP request needs common processing: logging, authentication, CORS headers, body parsing, rate limiting. Without middleware, every route handler would duplicate this code. Express middleware solves this with a **chain of responsibility** pattern. Each middleware function receives the request (`req`), the response (`res`), and a `next` function. It can:
- Process the request (parse body, validate token, add headers)
- End the request (send a response, blocking further middleware)
- Pass to the next middleware (`next()`)

In this project, a job creation request flows through: `CORS → Body Parser → Auth Middleware → Validation Middleware → Job Controller → Service → Prisma → Response`. Each middleware handles one concern. If auth fails, it sends a 401 response immediately — the request never reaches the controller. If validation fails, a 400 is returned. This separation keeps each middleware focused, testable, and reusable across routes.

**When To Use:**
- Every Express/Koa/Fastify application (middleware is the fundamental architectural pattern)
- Cross-cutting concerns that apply to multiple routes (auth, logging, CORS, rate limiting)
- Request transformation (body parsing, compression, content negotiation)
- Response transformation (adding headers, caching)

**When Not To Use:**
- Route-specific logic (that belongs in controllers)
- Business logic (that belongs in services)
- Complex orchestrations that need to share state across middleware (use a dedicated module instead)
- Async operations where error handling would be better in the route handler

**Common Interview Question:**
*"What is the difference between application-level and router-level middleware in Express?"*

Application-level middleware is registered with `app.use()` and applies to every route in the application. In this project, `app.use(cors())`, `app.use(express.json())`, and `app.use(requestLogger)` are application-level — every request passes through them. Router-level middleware is registered on a specific router: `router.use(auth)` on the job routes. Only requests to `/api/jobs/*` go through auth middleware. The `/api/auth/login` route doesn't need authentication, so it doesn't use that router-level middleware. This scoping reduces unnecessary work — public routes skip auth middleware entirely. The same middleware function can be used at either level, giving you fine-grained control over what applies where.

**Real World Example:**
Stripe's API uses middleware for rate limiting. Each request passes through a rate-limiting middleware that checks the API key's usage against its rate limit. If exceeded, the middleware returns 429 Too Many Requests — the request never reaches the controller. This is middleware-level rate limiting: it happens before any business logic, preserving server resources. Stripe also uses middleware for idempotency: if a request includes an `Idempotency-Key` header, the middleware checks if that key was already processed and returns the cached response without hitting the service layer.

---

## Concept: Docker Containers

**Why It Exists:**
"Works on my machine" is the classic DevOps problem. Docker solves it by packaging the application with its entire environment — operating system dependencies, Node.js version, PostgreSQL client, environment variables, and configuration — into a **container image**. This image runs identically on your Mac, on a Linux CI server, and on a production cloud instance. In this project, Docker Compose orchestrates three containers: `api` (Node.js/Express), `db` (PostgreSQL 16), and optional `flutter-builder`. The `api` container uses a bind mount (`./backend:/app`) so code changes on the host are reflected in the container immediately — you get Docker's consistency with local development speed. The database container uses a named volume (`postgres_data`) so data persists across restarts.

**When To Use:**
- Any project with backend services that need to run in production
- Teams with multiple developers who use different operating systems
- Projects that depend on specific infrastructure versions (PostgreSQL 16, Redis 7, etc.)
- CI/CD pipelines (run tests in the same environment as production)

**When Not To Use:**
- Pure Flutter/Dart projects with no backend dependencies
- Single-developer projects where the developer controls their environment
- Resource-constrained environments where Docker overhead matters (Docker Desktop on macOS uses 2-4GB RAM)

**Common Interview Question:**
*"What's the difference between a Docker image and a Docker container?"*

A Docker image is a read-only template containing the application code, runtime, libraries, and configuration. Think of it as a class definition. A Docker container is a running instance of that image — it has a writable layer, a filesystem, network ports, and a process. Think of it as an object instance. You build an image once (`docker build -t jobpilot-api .`) and create many containers from it (`docker run jobpilot-api`). In this project, the Dockerfile defines the image (FROM node:20 → copy package.json → npm ci → copy source → CMD node server.js), and Docker Compose creates two containers from that image (one for development with hot reload, one for production with optimizations).

**Real World Example:**
Netflix uses containers extensively. Every microservice runs in a Docker container, managed by their internal orchestration platform (based on Titus). When a developer commits code, CI builds a new Docker image, runs tests inside the same container environment, and deploys to production. The guarantee that the container in testing is identical to the one in production eliminates environment-related bugs. Netflix's deployment frequency (thousands per day) would be impossible without containerization — they rely on Docker's consistency to move fast without breaking things.

---

## Concept: Environment Variables

**Why It Exists:**
Hardcoding configuration in source code is a security risk and a maintenance nightmare. Your database password, JWT secret, and API keys should never appear in Git. Environment variables externalize configuration from code, following the **12-Factor App** methodology. In this project, environment variables manage: `DATABASE_URL` (changes between dev, test, prod), `JWT_SECRET` (sensitive, different per environment), `NODE_ENV` (controls logging verbosity, error stack traces), `PORT` (3000 locally, assigned by hosting platform in production), and `UPLOAD_DIR` (local filesystem or cloud storage path). The `.env.example` file documents all required variables without exposing secrets. The `config/environment.js` file validates that all required variables are present at startup — the app fails fast with a clear error message rather than crashing mysteriously later.

**When To Use:**
- Every application that runs in more than one environment (dev, staging, prod)
- Any app that stores secrets (database passwords, API keys, encryption secrets)
- Projects deployed to cloud platforms (Heroku, Railway, AWS all use env vars)
- Dockerized applications (env vars are the standard way to configure containers)

**When Not To Use:**
- Configuration that doesn't change between environments (this goes in constants)
- Complex configuration that needs nesting or structure (use a config file + env var for the file path)
- Secrets that need rotation without deployment (use a secrets manager like Vault or AWS Secrets Manager)
- Configuration that changes at runtime (env vars require a restart)

**Common Interview Question:**
*"Explain the 12-Factor App methodology for configuration. What is 'strict separation of config from code'?"*

The 12-Factor App manifesto states that configuration should be stored in environment variables, not in code. A codebase should be deployable to any environment without modification. The key practices are: (1) Never hardcode config values — every URL, credential, or toggle belongs in an env var. (2) Never group env vars by environment — instead of `development.js`, `production.js`, use individual vars that don't change between deploys. (3) Validate config at startup — if required vars are missing, crash immediately with a clear message. In this project, `config/environment.js` does exactly this: it loads `.env` with dotenv, validates every variable with Joi, and crashes on startup with an error like "Environment validation error: DATABASE_URL is required". This fails fast rather than producing cryptic runtime errors.

**Real World Example:**
Heroku's entire platform is built around environment variables. When you deploy an app, you set config vars via `heroku config:set DATABASE_URL=postgres://...`. Heroku stores these encrypted and injects them into the container at runtime. If a database credential is compromised, you rotate it in seconds: `heroku config:set DATABASE_URL=new-url && heroku restart`. No code changes, no redeploy, no git commit. This operational flexibility is why env vars are the standard for cloud-native applications.

---

## Concept: RESTful API Design

**Why It Exists:**
REST (Representational State Transfer) is an architectural style for designing networked applications. It uses HTTP methods as verbs and URLs as nouns. Instead of `POST /createJob` or `GET /deleteUser?id=5`, REST says: use `POST /api/jobs` to create, `DELETE /api/users/5` to delete. This consistency makes APIs predictable and self-documenting. Once a developer knows the resource model (users, jobs, resumes), they can infer 90% of the API without reading documentation. REST also leverages HTTP semantics — status codes (201 Created, 400 Bad Request, 404 Not Found), headers (Content-Type, Authorization), and caching (ETags, Cache-Control) — rather than reinventing them.

**When To Use:**
- Public APIs where consistency and discoverability matter
- Mobile apps that consume APIs (REST is universally supported)
- CRUD-heavy applications (REST maps naturally to Create/Read/Update/Delete)
- Projects where HTTP caching is beneficial

**When Not To Use:**
- Real-time applications (WebSockets are better for push-based communication)
- Complex, deeply nested data requirements (GraphQL reduces over-fetching)
- Internal service-to-service communication (gRPC is more efficient)
- Apps where the client needs to subscribe to data changes (consider Server-Sent Events or WebSockets)

**Common Interview Question:**
*"What are the key constraints of REST? What does it mean for an API to be truly RESTful?"**

REST has six architectural constraints defined by Roy Fielding: (1) **Client-Server** — separation of concerns between UI and data storage. (2) **Stateless** — each request contains all information needed to process it (no server-side session state). (3) **Cacheable** — responses must define themselves as cacheable or not. (4) **Uniform Interface** — consistent resource identification (URLs), representation manipulation (representations include enough info to modify resources), self-descriptive messages (metadata like content type), and HATEOAS (hypermedia as the engine of application state — links in responses guide clients). (5) **Layered System** — intermediaries (proxies, gateways, load balancers) can be inserted without client modification. (6) **Code on Demand (optional)** — servers can extend client functionality via scripts. Most APIs (including this one) are "RESTful" rather than fully RESTful — we satisfy constraints 1-3 and 5 but skip HATEOAS for pragmatic reasons. Adding links to every response would increase payload size without proportional benefit for a mobile app.

**Real World Example:**
GitHub's API v3 is the gold standard for RESTful API design. Resources are consistently named: `GET /repos/:owner/:repo/issues`, `POST /repos/:owner/:repo/issues`, `PATCH /repos/:owner/:repo/issues/:number`. Status codes are used correctly: 200 for success, 201 for creation, 422 for validation errors, 304 for not modified (using ETags). Pagination uses standard query parameters (`page`, `per_page`) and Link headers for next/prev navigation. Responses include URLs to related resources. This consistency is why thousands of tools (GitHub CLI, GitHub Desktop, IDE integrations) all work seamlessly with the GitHub API — they follow REST conventions.

---

## Concept: Freezed (Deep Dive)

**Why It Exists:**
Dart classes need `==`, `hashCode`, `toString`, `copyWith`, and often `toJson`/`fromJson`. Writing these manually is tedious, error-prone, and clutters the file. Add one field? Update five methods. Freezed is a code generator that produces all of these from a single `@freezed` annotation. It also introduces **union types** (sealed classes) which are essential for modeling BLoC states and events. A state like `AuthState` can be `initial`, `loading`, `authenticated(user)`, or `error(message)` — each is a distinct type but they share the `AuthState` supertype. Dart 3's sealed classes + Freezed give you exhaustive pattern matching: the compiler forces you to handle every case in a `when` or `map` statement. Forgot to handle `AuthError` in your UI? Won't compile.

**When To Use:**
- All data classes that need `==`/`hashCode`/`toString`/`copyWith`
- BLoC events and states (union types are essential)
- API request/response models (with `json_serializable`)
- Value objects in the Domain layer
- Any class where you'd otherwise write boilerplate

**When Not To Use:**
- Classes that don't need equality or copy (use a simple class)
- Performance-critical code that creates millions of objects in tight loops (unlikely in Flutter)
- Prototypes where you want maximum iteration speed (skip build_runner)

**Common Interview Question:**
*"How do Freezed's union types work with Dart 3 sealed classes? What does `when` provide that `if/else` doesn't?"*

Freezed generates a `when` method that requires you to handle every subclass exhaustively. If `AuthState` has four variants (`AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`), calling `state.when(initial: ..., loading: ..., authenticated: ..., error: ...)` forces you to provide a callback for each. If you add a new variant (e.g., `AuthTwoFactorRequired`), all `when` calls will fail to compile until you handle the new case. This is the compiler providing correctness guarantees that `if/else` or `switch` cannot match without discipline. With Dart 3 sealed classes, Freezed marks each variant class as `sealed`, meaning the compiler knows all possible subtypes at compile time. This enables `when` and `map` to be exhaustive. You can still use `maybeWhen` or `whenOrNull` when you only care about specific states, but the exhaustive variants are always available for safety.

**Real World Example:**
Google's Flutter team uses Freezed for their internal tooling. The `DevTools` debugging suite uses Freezed for all state classes. When they added a new profiling mode, they created a new union variant — and the compiler told them every location that needed to handle it. What could have been a subtle runtime bug (forgetting to update the UI for the new state) became a compile-time error caught before code review.

---

## Concept: Error Handling with Either

**Why It Exists:**
Exceptions in Dart are unchecked — the compiler doesn't tell you what can throw. A method that fetches jobs might throw `SocketException`, `DioException`, `FormatException`, or `TimeoutException`. You only discover these at runtime. The `Either<Failure, T>` pattern from functional programming makes errors **explicit in the type signature**: `Future<Either<Failure, List<Job>>>`. The caller must handle both the Success (Right) and Failure (Left) cases. The `fold` method ensures exhaustive handling. This eliminates entire categories of bugs: uncaught exceptions, forgotten error handling, and silent failures. In this project, `Failure` is a sealed class with variants like `ServerFailure`, `NetworkFailure`, `AuthFailure`, and `ValidationFailure`. Each carries a user-friendly message. The BLoC folds over the Either and emits the appropriate state — either `JobsLoaded(jobs)` or `JobError(message)`.

**When To Use:**
- Repository return types (the boundary between data and domain)
- Use case return types (the boundary between domain and presentation)
- Any method that can fail in a recoverable way
- APIs where consumers must handle errors (don't use for unrecoverable errors like "file not found at hardcoded path")

**When Not To Use:**
- Simple scripts where you don't care about error types
- Internal methods where exceptions are fine (the pattern adds ceremony for internal calls)
- Unrecoverable errors (out of memory, stack overflow) — those should crash
- Performance-critical hot paths where allocating Either objects adds overhead

**Common Interview Question:**
*"What is the difference between `Either` and `try/catch`? When would you use one over the other?"*

`Either` makes errors explicit in the return type — the consumer knows what can go wrong and must handle it. `try/catch` makes errors invisible — a method signature doesn't reveal what it might throw, and forgetting to catch results in a runtime crash. Use `Either` at architectural boundaries (repository → use case → BLoC) where errors are part of the domain model. Use `try/catch` at the edges of the system (transforming DioExceptions into Failures in the DataSource) where you're dealing with framework-specific exceptions that shouldn't leak into the Domain layer. In this project, both patterns coexist: `try/catch` in the DataSource catches Dio exceptions, and `Either` in the repository return type makes the failure explicit to the rest of the app.

**Real World Example:**
The Dart `package:http` client throws exceptions for network errors — there's no `Either` in the standard library. But production apps at Google wrap HTTP calls in repositories that return `Either`. A Google Maps API client might return `Either<GeocodingFailure, Coordinates>`. The `GeocodingFailure` could be `RateLimited`, `InvalidAddress`, `NoInternet`, or `ServerError`. Each is handled differently: rate limiting shows a retry timer, invalid address highlights the input field, no internet shows an offline banner. This granular error handling would be impossible with a generic `Exception` catch.
