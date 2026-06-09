# JobPilot AI — Backend Explanations

> **Purpose:** Deep-dive into the Express.js backend architecture, patterns, and rationale.  
> **Target Audience:** Flutter developer (3+ yrs) learning backend development.  
> **Last Updated:** June 2026

---

## Table of Contents

1. [Folder Structure Explained](#1-folder-structure-explained)
2. [Request Lifecycle](#2-request-lifecycle)
3. [Error Handling Strategy](#3-error-handling-strategy)
4. [Authentication Flow](#4-authentication-flow)
5. [File Upload with Multer](#5-file-upload-with-multer)
6. [Validation Strategy](#6-validation-strategy)
7. [Database Migrations](#7-database-migrations)
8. [Environment Configuration](#8-environment-configuration)

---

## 1. Folder Structure Explained

```
backend/
├── prisma/
│   ├── schema.prisma              # Single source of truth for data model
│   └── migrations/                # Auto-generated SQL migration files
│
├── src/
│   ├── config/
│   │   ├── database.js            # Prisma client singleton
│   │   ├── environment.js         # Env var validation (dotenv + Joi)
│   │   └── cors.js                # CORS whitelist configuration
│   │
│   ├── controllers/
│   │   ├── auth.controller.js     # Login, register, refresh, logout
│   │   ├── job.controller.js      # CRUD for job applications
│   │   └── resume.controller.js   # Upload, list, delete resumes
│   │
│   ├── middleware/
│   │   ├── auth.middleware.js      # JWT verification, attaches req.user
│   │   ├── error.middleware.js     # Global error handler (catch-all)
│   │   ├── upload.middleware.js    # Multer configuration for file uploads
│   │   └── validate.middleware.js  # Joi schema runner
│   │
│   ├── routes/
│   │   ├── index.js               # Aggregates all route modules
│   │   ├── auth.routes.js         # /api/auth/*
│   │   ├── job.routes.js          # /api/jobs/*
│   │   └── resume.routes.js       # /api/resumes/*
│   │
│   ├── services/
│   │   ├── auth.service.js        # Password hashing, JWT generation
│   │   ├── job.service.js         # Job CRUD, business rules, stats
│   │   └── resume.service.js      # File storage, resume metadata
│   │
│   ├── validators/
│   │   ├── auth.validator.js      # Login/register Joi schemas
│   │   ├── job.validator.js       # Job CRUD Joi schemas
│   │   └── resume.validator.js    # Upload metadata Joi schemas
│   │
│   ├── utils/
│   │   ├── ApiError.js            # Custom error class with statusCode
│   │   ├── ApiResponse.js         # Standardized JSON response helper
│   │   ├── asyncHandler.js        # Wraps async route handlers
│   │   └── token.js               # JWT sign/verify helpers
│   │
│   └── app.js                     # Express app (middleware stack, routes)
│
├── scripts/
│   └── seed.js                    # Database seed script for development
│
├── uploads/                       # Local file storage (gitignored)
├── server.js                      # Entry point: imports app, starts listening
├── Dockerfile
├── .env.example
├── .gitignore
└── package.json
```

### Why Each Folder Exists

**`prisma/`** — Contains the database schema and migration history. The `schema.prisma` file is the single source of truth for the data model. Every time you change it, Prisma generates a migration (a SQL file) that updates the database schema safely. This folder is checked into version control because migrations are code — they must be reviewable, replayable, and shareable across the team.

**`src/config/`** — Centralizes all configuration logic. The `database.js` file creates a single Prisma client instance and exports it (singleton pattern prevents multiple connections). The `environment.js` file validates all environment variables at startup using Joi — if a required variable is missing, the server crashes immediately with a clear error instead of failing mysteriously on the first request that needs it. The `cors.js` file whitelists allowed origins (Flutter dev server, production domain).

**`src/controllers/`** — The HTTP interface layer. Controllers parse request data (`req.params`, `req.query`, `req.body`, `req.user`), call the appropriate service method, and format the response. They should be thin — no business logic, no direct database calls, no file processing. If you find yourself writing `if` statements about business rules in a controller, move that to a service. Controllers exist to translate between HTTP and application logic.

**`src/services/`** — The business logic layer. This is where the actual work happens: password hashing, JWT generation, job CRUD with validation, file processing. Services are pure JavaScript classes that don't import Express or know about HTTP. This makes them testable without starting a server — you can instantiate a service and call its methods directly in unit tests. Services call Prisma for database operations and throw `ApiError` for business rule violations.

**`src/middleware/`** — Cross-cutting concerns that process requests before they reach controllers. Each middleware function has one job: `auth.middleware.js` verifies JWT tokens, `upload.middleware.js` handles multipart file parsing, `validate.middleware.js` runs Joi schemas, `error.middleware.js` catches thrown errors. Middleware is reusable across routes — auth middleware applies to all `/api/jobs` and `/api/resumes` routes but not to `/api/auth/login`.

**`src/routes/`** — URL definitions that wire together HTTP methods, middleware, and controllers. Routes are the thinnest layer — they only define the mapping from URLs to handlers. The `index.js` aggregator mounts all route modules under their prefixes (`/api/auth`, `/api/jobs`, `/api/resumes`).

**`src/validators/`** — Joi schema definitions for request body validation. Separating validators from controllers and routes keeps them focused, testable, and composable. A single validator schema can be reused (e.g., the `createJobSchema` fields are extracted and reused in `updateJobSchema` with `.min(1)` for partial updates).

**`src/utils/`** — Shared utilities used across layers. `ApiError` is a custom Error subclass with a `statusCode` property — throwing `new ApiError(404, 'Not found')` in any layer causes the error middleware to return a properly formatted 404 response. `ApiResponse` formats successful responses consistently. `asyncHandler` wraps async route handlers so thrown errors are caught and forwarded to the error middleware without manual `try/catch` in every handler.

### Why Not a Different Structure?

Some Express projects use a **feature-based structure** (a folder per feature containing its own routes, controllers, services, validators). That works well for large teams where each team owns a feature. For this project's size, a **layer-based structure** (all routes together, all controllers together) is simpler — you can see every route in one index file, every controller in one folder, and you don't repeat shared middleware setup across feature folders.

Some projects flatten everything into `routes/` with inline logic. This works for 5-route APIs but becomes unmaintainable at this project's scale (15+ endpoints across 3 resources). The layered approach adds file overhead but ensures each file has exactly one reason to change.

---

## 2. Request Lifecycle

### Complete HTTP Request Journey

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    REQUEST LIFECYCLE (Job Creation)                          │
│                                                                              │
│  CLIENT (Flutter)                                                             │
│  ┌──────────────────────────────────────────────────────────────────────────┐│
│  │  dio.post('/api/jobs', data: { company, role, status })                 ││
│  │  headers: { Authorization: 'Bearer <accessToken>' }                     ││
│  └──────────────────────────────────────────────────────────────────────────┘│
│                                      │                                       │
│                                      ▼                                       │
│  EXPRESS.JS SERVER                                                            │
│                                                                              │
│  1. app.js — Application Setup                                                │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  app.use(cors())                    ← CORS headers                    │ │
│     │  app.use(express.json())            ← Body parsing (JSON)            │ │
│     │  app.use(requestLogger)             ← Request logging                │ │
│     │  app.use('/api', routes)            ← Mount all routes               │ │
│     │  app.use(errorHandler)              ← Global error handler (last)    │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  2. routes/index.js — Route Matching                                          │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  router.use('/auth', authRoutes)     ← Matches /api/auth/*           │ │
│     │  router.use('/jobs', jobRoutes)      ← Matches /api/jobs/*           │ │
│     │  router.use('/resumes', resumeRoutes) ← Matches /api/resumes/*       │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  3. routes/job.routes.js — Route Definition                                   │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  router.use(auth)                   ← Auth middleware (all job       │ │
│     │  router.post('/', validate(schema), ← routes require auth)           │ │
│     │          jobController.create)                                       │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  4. middleware/auth.middleware.js — JWT Verification                          │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  Extract Authorization header                                        │ │
│     │  Verify JWT signature + expiry                                       │ │
│     │  Attach decoded payload to req.user = { id, email }                  │ │
│     │  Call next()                                                         │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  5. middleware/validate.middleware.js — Request Body Validation               │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  Run createJobSchema.validate(req.body)                              │ │
│     │  If invalid → throw ApiError(400, messages)                          │ │
│     │  If valid → replace req.body with sanitized value                    │ │
│     │  Call next()                                                         │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  6. controllers/job.controller.js — HTTP Handler                              │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  Extract: req.user.id, req.body                                     │ │
│     │  Call: jobService.createJob(userId, body)                            │ │
│     │  Response: res.status(201).json({ success: true, data: job })       │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  7. services/job.service.js — Business Logic                                  │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  Validate business rules: check active app limit                    │ │
│     │  Call: prisma.job.create({ data: { ...body, userId } })             │ │
│     │  Return created job object                                           │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  8. prisma → PostgreSQL — Database Query                                      │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  Prisma generates: INSERT INTO jobs (id, company, role, status,      │ │
│     │  userId, createdAt, updatedAt) VALUES ($1, $2, $3, $4, $5, $6, $7) │ │
│     │  RETURNING *                                                         │ │
│     │  PostgreSQL executes, returns the row                                │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  9. Response flows back                                                     │
│     ┌──────────────────────────────────────────────────────────────────────┐ │
│     │  Service returns job object → Controller sends 201 JSON              │ │
│     │  Express serializes response and sends to client                     │ │
│     │  Error middleware is skipped (no error was thrown)                    │ │
│     └──────────────────────────────────────────────────────────────────────┘ │
│                                      │                                       │
│                                      ▼                                       │
│  CLIENT (Flutter)                                                             │
│  ┌──────────────────────────────────────────────────────────────────────────┐│
│  │  Dio receives response → Status 201                                     ││
│  │  JobModel.fromJson(response.data) → Job.toEntity()                      ││
│  │  Repository returns Either<Failure, Job> → UseCase → BLoC              ││
│  └──────────────────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────────────────┘
```

### The asyncHandler Pattern

Notice that controllers never use `try/catch`. Instead, they're wrapped in `asyncHandler`:

```javascript
// utils/asyncHandler.js
module.exports = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};
```

This catches any thrown error (or rejected promise) and forwards it to Express's error middleware via `next(err)`. Without this, every async controller would need `try/catch` wrapping. The pattern is essential because Express doesn't catch promise rejections automatically — an unhandled rejection would crash the server (or silently swallow the error in newer Node versions). This is the single most common Express bug.

### Response Flow Diagram

```
RESPONSE PATH:
Controller → (optional: error middleware) → Express serialization → Network → Client

ERROR RESPONSE PATH:
Any layer throws ApiError → error.middleware.js catches it → 
  res.status(err.statusCode).json({ success: false, message, ... })
```

---

## 3. Error Handling Strategy

### Three-Layer Error Architecture

The backend uses three complementary mechanisms for error handling:

**Layer 1: Custom Error Classes (`utils/ApiError.js`)**

```javascript
class ApiError extends Error {
  constructor(statusCode, message, details = null) {
    super(message);
    this.statusCode = statusCode;
    this.details = details; // Optional field-level error details
    this.isOperational = true; // Distinguishes expected errors from programming bugs
  }
}
```

`ApiError` extends the native `Error` class with a `statusCode` property. The `isOperational` flag distinguishes expected errors (invalid input, not found, unauthorized) from programming bugs (undefined variable, null reference). Operations errors are handled gracefully; programming bugs crash the process and alert the developer.

Usage across layers:
```javascript
// In a service (business rule violation)
throw new ApiError(400, 'Maximum 50 active applications allowed');

// In middleware (auth failure)
throw new ApiError(401, 'Invalid or expired token');

// In a validator (schema validation failure)
throw new ApiError(400, 'Email is required; Password must be at least 8 characters');
```

**Layer 2: Global Error Middleware (`middleware/error.middleware.js`)**

```javascript
module.exports = (err, req, res, next) => {
  // 1. Handle known operational errors
  if (err.isOperational) {
    return res.status(err.statusCode).json({
      success: false,
      message: err.message,
      ...(err.details && { details: err.details }),
    });
  }

  // 2. Handle Prisma-specific errors
  if (err.code === 'P2002') { // Unique constraint violation
    return res.status(409).json({
      success: false,
      message: 'A record with this value already exists',
    });
  }
  if (err.code === 'P2025') { // Record not found
    return res.status(404).json({
      success: false,
      message: 'Record not found',
    });
  }

  // 3. Handle unknown errors (programming bugs)
  console.error('UNEXPECTED ERROR:', err);
  return res.status(500).json({
    success: false,
    message: 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};
```

This middleware is registered **last** in the Express middleware stack (after all routes). Any error thrown with `throw new ApiError(...)` or passed via `next(err)` anywhere in the application ends up here. The middleware categorizes the error:
- **Operational errors** (isOperational=true): Return the appropriate status code and message
- **Prisma errors** (code starts with 'P'): Map to user-friendly messages
- **Unknown errors** (programming bugs): Log the full error, return 500, include stack trace only in development

**Layer 3: Consistent Response Format (`utils/ApiResponse.js`)**

```javascript
class ApiResponse {
  static success(res, data, message = 'Success', statusCode = 200) {
    return res.status(statusCode).json({ success: true, message, data });
  }
  static paginated(res, data, pagination, message = 'Success') {
    return res.status(200).json({ success: true, message, data, pagination });
  }
}
```

Every response follows the same envelope:
- Success: `{ success: true, message: "...", data: {...} }`
- Error: `{ success: false, message: "..." }`
- Paginated: `{ success: true, message: "...", data: [...], pagination: { page, limit, total, totalPages } }`

This consistency is crucial for the Flutter client — the `ErrorInterceptor` in Dio can parse any error response the same way, and the `ApiResponse` helper on the backend ensures no endpoint accidentally deviates from the format.

### Error Flow

```
SERVICE throws ApiError(404, 'Job not found')
  → Express catches (via asyncHandler or native Express error capture)
  → Skips all remaining middleware/routes
  → Error middleware receives err
  → Checks err.isOperational → true
  → Sends: { success: false, message: 'Job not found' }
  → Status: 404
```

```
CONTROLLER calls prisma.job.findUniqueOrThrow() and it throws P2025
  → Same error middleware catches it
  → Checks err.code === 'P2025' → true
  → Sends: { success: false, message: 'Record not found' }
  → Status: 404
```

```
MIDDLEWARE can't connect to database and throws generic Error
  → Error middleware catches it
  → err.isOperational → undefined (false)
  → err.code → undefined
  → Logs full error with stack trace
  → Sends: { success: false, message: 'Internal server error' }
  → Status: 500
```

---

## 4. Authentication Flow

### Architecture

Authentication uses **JWT with a two-token strategy**. The design balances security (short-lived access tokens) with UX (automatic refresh without re-login).

```
┌─────────────────────────────────────────────────────────────────────┐
│                      AUTH ARCHITECTURE                                │
│                                                                       │
│  REGISTRATION:                                                         │
│  POST /api/auth/register                                              │
│  Body: { name, email, password }                                      │
│  1. Joi validates input (email format, password min 8 chars)          │
│  2. AuthService.register():                                           │
│     a. Check if email already exists → 409 if yes                     │
│     b. bcrypt.hash(password, 12) ← salt rounds                       │
│     c. prisma.user.create({ data: { name, email, password: hash } })  │
│     d. jwt.sign({ id, email }, JWT_SECRET, { expiresIn: '15m' })      │
│     e. jwt.sign({ id, type: 'refresh' }, JWT_SECRET, { expiresIn: '7d' })  │
│     f. Store refresh token hash in DB (for revocation)                │
│     g. Return { user, accessToken, refreshToken }                     │
│                                                                       │
│  LOGIN:                                                                │
│  POST /api/auth/login                                                 │
│  Body: { email, password }                                            │
│  1. Joi validates input                                                │
│  2. AuthService.login():                                              │
│     a. prisma.user.findUnique({ where: { email } })                    │
│     b. If not found → throw ApiError(401, 'Invalid credentials')      │
│     c. bcrypt.compare(password, user.password)                         │
│     d. If mismatch → throw ApiError(401, 'Invalid credentials')       │
│     e. Generate tokens (same as registration)                          │
│     f. Return { user, accessToken, refreshToken }                      │
│                                                                       │
│  TOKEN REFRESH:                                                         │
│  POST /api/auth/refresh                                                │
│  Body: { refreshToken }                                                │
│  1. Verify refreshToken signature & expiry                              │
│  2. Check token is not revoked in DB                                   │
│  3. Issue NEW access + refresh tokens (rotation)                       │
│  4. Revoke old refresh token in DB                                     │
│  5. Return { accessToken, refreshToken }                               │
│                                                                       │
│  LOGOUT:                                                               │
│  POST /api/auth/logout                                                 │
│  Body: { refreshToken }                                                │
│  1. Mark refresh token as revoked in DB                                │
│  2. Return { success: true }                                           │
└─────────────────────────────────────────────────────────────────────┘
```

### Password Hashing with bcrypt

```javascript
const bcrypt = require('bcrypt');
const SALT_ROUNDS = 12;

async function hashPassword(password) {
  return bcrypt.hash(password, SALT_ROUNDS);
}

async function verifyPassword(password, hash) {
  return bcrypt.compare(password, hash);
}
```

Key points about bcrypt:
- **Salt rounds (12):** Higher is slower but more secure. 12 rounds takes ~250ms on modern hardware — fast enough for UX, slow enough to make brute-force attacks impractical (a single GPU can try ~100 bcrypt(12) hashes/second vs ~100M SHA-256 hashes/second).
- **Automatic salting:** bcrypt generates a unique salt for each password. Even if two users have the same password, their hashes will differ.
- **Constant-time comparison:** bcrypt.compare is resistant to timing attacks — an attacker cannot tell if the first byte of the hash matches.

### JWT Token Generation

```javascript
// utils/token.js
const jwt = require('jsonwebtoken');

exports.generateAccessToken = (userId, email) => {
  return jwt.sign(
    { id: userId, email },
    process.env.JWT_SECRET,
    { expiresIn: '15m' }
  );
};

exports.generateRefreshToken = (userId) => {
  return jwt.sign(
    { id: userId, type: 'refresh' },
    process.env.JWT_REFRESH_SECRET,
    { expiresIn: '7d' }
  );
};

exports.verifyToken = (token, secret) => {
  return jwt.verify(token, secret);
};
```

The access token contains `{ id, email, iat, exp }`. Never include sensitive data (password, phone number) in the token — it's Base64-encoded (not encrypted) and could be decoded if intercepted.

### Auth Middleware in Action

```javascript
// middleware/auth.middleware.js
const { verifyToken } = require('../utils/token');
const ApiError = require('../utils/ApiError');

module.exports = (req, res, next) => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new ApiError(401, 'Authentication required');
  }

  try {
    const token = authHeader.split(' ')[1];
    const decoded = verifyToken(token, process.env.JWT_SECRET);
    req.user = decoded; // { id, email, iat, exp }
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      throw new ApiError(401, 'Token expired');
    }
    throw new ApiError(401, 'Invalid token');
  }
};
```

The middleware extracts the token from the `Authorization: Bearer <token>` header, verifies it, and attaches the decoded payload to `req.user`. All downstream code (controllers, services) accesses the authenticated user via `req.user.id`. If the token is missing, expired, or invalid, a 401 response is returned — the request never reaches the controller.

### Protected vs Public Routes

```
PUBLIC (no auth):
  POST   /api/auth/register
  POST   /api/auth/login
  POST   /api/auth/refresh

PROTECTED (auth required):
  GET    /api/jobs
  POST   /api/jobs
  PUT    /api/jobs/:id
  DELETE /api/jobs/:id
  GET    /api/resumes
  POST   /api/resumes
  DELETE /api/resumes/:id
```

Protected routes apply auth middleware at the router level:
```javascript
// routes/job.routes.js
const router = require('express').Router();
router.use(auth); // All routes below require auth
```

Public routes don't use auth middleware:
```javascript
// routes/auth.routes.js
const router = require('express').Router();
router.post('/login', validate(loginSchema), authController.login); // No auth middleware
```

### Security Considerations

1. **HTTPS only:** All token transmission happens over HTTPS. Without encryption, tokens can be intercepted via man-in-the-middle attacks.
2. **Token storage in Flutter:** Tokens are stored in `flutter_secure_storage` (iOS Keychain / Android EncryptedSharedPreferences), not in plain text.
3. **Refresh token rotation:** Each refresh invalidates the old token. A stolen refresh token can be used only once before the legitimate user's next refresh fails, alerting them to the compromise.
4. **Rate limiting:** Login and register endpoints should be rate-limited (e.g., 5 attempts per minute per IP) to prevent brute-force attacks. This is not yet implemented but is a standard addition using `express-rate-limit`.
5. **Audit logging:** All auth events (login, failed login, token refresh, logout) are logged with timestamp, IP, and user agent.

---

## 5. File Upload with Multer

### Why Multer

Express doesn't natively handle `multipart/form-data` (the format used for file uploads). Multer is a middleware that parses multipart bodies and makes the uploaded file available as `req.file`. Without Multer, you'd need to manually parse the raw multipart stream — a complex, error-prone task involving boundary detection, MIME type parsing, and streaming to disk.

Multer is chosen over alternatives because:
- **De facto standard:** It's the most widely used Express upload middleware. Community knowledge, examples, and troubleshooting are abundant.
- **Storage engine abstraction:** You can swap filesystem storage for S3/cloud storage by changing one configuration line (from `multer.diskStorage` to `multer-s3`).
- **Built-in validation:** File size limits, MIME type filtering, and file count limits are configured in the Multer options — no custom validation code needed.

### Configuration

```javascript
// middleware/upload.middleware.js
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, process.env.UPLOAD_DIR || 'uploads/');
  },
  filename: (req, file, cb) => {
    // Unique filename: timestamp + random string + original extension
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
});

const fileFilter = (req, file, cb) => {
  const allowedMimes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ];
  
  if (allowedMimes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new ApiError(400, 'Only PDF and DOC/DOCX files are allowed'), false);
  }
};

const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
  },
});

module.exports = upload;
```

### How It Works

1. The Flutter client creates a `FormData` object containing the file and optional metadata fields.
2. Dio sends a `POST /api/resumes` request with `Content-Type: multipart/form-data`.
3. The route has `upload.single('resume')` middleware before the controller:
   ```javascript
   router.post('/', auth, upload.single('resume'), validate(metadataSchema), resumeController.upload);
   ```
4. Multer parses the multipart body:
   - Extracts the file from the `resume` field
   - Saves it to the `uploads/` directory with a unique filename
   - Attaches file metadata to `req.file`: `{ fieldname, originalname, encoding, mimetype, destination, filename, path, size }`
   - Extracts non-file fields and attaches them to `req.body`
5. If the file exceeds 5MB or has an invalid MIME type, Multer throws an error that the error middleware handles.
6. The controller reads `req.file` and `req.body`, calls the resume service to create a database record referencing the saved file.
7. The service creates a Prisma `Resume` record with `{ userId, fileName: req.file.filename, originalName: req.file.originalname, mimeType: req.file.mimetype, fileSize: req.file.size }`.

### Local vs Cloud Storage

| Aspect | Local (Current) | Cloud (Future: S3) |
|--------|----------------|-------------------|
| Storage engine | `multer.diskStorage` | `multer-s3` |
| File access | `GET /api/resumes/:id/file` | Presigned S3 URLs |
| Scalability | Single server only | Horizontal scaling |
| Backup | Manual | S3 lifecycle policies |
| Cost | Server disk space | S3 storage + transfer |
| Migration path | Immediate | Swap engine: `multer({ storage: multerS3({...}) })` |

The current setup uses local disk storage for simplicity. The abstraction layer (Multer's storage engine) makes it trivial to switch to S3 when needed. The controller and service don't know whether files are stored locally or in the cloud — they only interact with `req.file` and the file path stored in the database.

### File Access and Security

Uploaded files are stored with UUID-based filenames to prevent path traversal attacks (a user cannot guess another user's filename). File access is controlled through an authenticated endpoint:

```javascript
// In resume controller
exports.downloadFile = asyncHandler(async (req, res) => {
  const resume = await resumeService.getResumeById(req.params.id, req.user.id);
  const filePath = path.join(__dirname, '../../uploads', resume.fileName);
  
  if (!fs.existsSync(filePath)) {
    throw new ApiError(404, 'File not found');
  }
  
  res.setHeader('Content-Type', resume.mimeType);
  res.setHeader('Content-Disposition', `attachment; filename="${resume.originalName}"`);
  res.sendFile(filePath);
});
```

Files are never directly accessible via URL (no `https://api.jobpilot/uploads/file.pdf`). All file access goes through an authenticated route that verifies user ownership.

---

## 6. Validation Strategy

### Defense in Depth

Validation happens at multiple layers:

```
Layer 1: Flutter client (form validation) — UX only, not security
  → Email format check, password length, required fields

Layer 2: Joi schema (middleware) — API contract enforcement
  → Request body validation before controller

Layer 3: Service rules — Business logic validation
  → "Can this user edit this job?", "Active application limit"

Layer 4: Prisma schema — Database constraint validation
  → Foreign key constraints, unique constraints, enum values

Layer 5: PostgreSQL — Last line of defense
  → Column types, NOT NULL, CHECK constraints
```

### Why Joi

Joi is chosen because:
- **Declarative schemas:** Schemas read like documentation.
- **Sanitization:** `stripUnknown: true` removes unexpected fields, preventing mass assignment attacks.
- **Custom error messages:** `messages` key allows user-friendly error messages.
- **Composition:** Schemas can be combined, extended, and reused.
- **Express integration:** The validation middleware pattern is clean and reusable.

### Where Validation Happens

**Request body validation** happens in middleware, before the controller:

```javascript
// middleware/validate.middleware.js
module.exports = (schema) => (req, res, next) => {
  const { error, value } = schema.validate(req.body, {
    abortEarly: false,    // Report all errors, not just the first
    stripUnknown: true,   // Remove unexpected fields (security)
    allowUnknown: false,  // Reject requests with unknown fields
  });

  if (error) {
    const messages = error.details.map(d => d.message).join('; ');
    throw new ApiError(400, messages);
  }

  req.body = value; // Use sanitized values
  next();
};
```

This is used on routes:
```javascript
router.post('/', validate(createJobSchema), jobController.create);
```

**Business rule validation** happens in services:
```javascript
// services/job.service.js
async createJob(userId, data) {
  // Business rule: max 50 active applications
  const activeCount = await prisma.job.count({
    where: { userId, status: { in: ['applied', 'interview'] } },
  });
  if (activeCount >= 50) {
    throw new ApiError(400, 'Maximum 50 active applications allowed');
  }
  // ... create job
}
```

### Sample Validator Schemas

```javascript
// validators/auth.validator.js
const Joi = require('joi');

const registerSchema = Joi.object({
  name: Joi.string().min(2).max(100).required(),
  email: Joi.string().email().required(),
  password: Joi.string()
    .min(8)
    .max(128)
    .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .message('Password must contain uppercase, lowercase, and number')
    .required(),
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

// validators/job.validator.js
const createJobSchema = Joi.object({
  company: Joi.string().min(1).max(200).required(),
  role: Joi.string().min(1).max(200).required(),
  status: Joi.string()
    .valid('saved', 'applied', 'interview', 'offer', 'rejected')
    .default('saved'),
  appliedDate: Joi.date().iso().default(() => new Date()),
  notes: Joi.string().max(2000).allow('', null),
  resumeId: Joi.string().uuid().allow(null),
});
```

### Why Not Validate in Controllers?

Some Express tutorials show validation in controllers:
```javascript
exports.create = async (req, res) => {
  if (!req.body.company) return res.status(400).json({ ... });
  if (!req.body.role) return res.status(400).json({ ... });
  // ...
};
```

This scatters validation across controllers, making it inconsistent and untestable. With Joi schemas in dedicated validator files, you can:
1. Test validation independently of controllers
2. Reuse schemas across routes (e.g., `createJobSchema` fields are reused in `updateJobSchema`)
3. Change validation rules in one place
4. Read all validation rules at a glance

---

## 7. Database Migrations

### Why Prisma Migrations

A database schema changes over time — new tables, new columns, new constraints. Without a migration system, developers manually run SQL scripts against their databases, leading to:
- "Works on my machine" — different databases have different schemas
- No version control — you don't know which schema changes have been applied
- No rollback — if a migration breaks, you must manually undo SQL
- No review — schema changes skip code review because they're applied directly

Prisma Migrations solve all of these:

1. **Declarative schema:** You define the desired state in `schema.prisma`.
2. **Auto-generated SQL:** `npx prisma migrate dev` diffs your schema against the current database state and generates a migration SQL file.
3. **Version control:** Migration files are committed to Git — they're code.
4. **Reproducible:** Any developer runs `npx prisma migrate deploy` to apply all pending migrations in order.
5. **Reviewable:** Migration SQL files are reviewed in PRs just like any other code change.

### Migration Workflow

```
DEVELOPMENT:
1. Edit schema.prisma (add a column, new model, etc.)
2. npx prisma migrate dev --name add_notes_to_jobs
   → Generates: prisma/migrations/20260601000000_add_notes_to_jobs/migration.sql
   → Applies it to your local database
3. Commit schema.prisma + migration files to Git

STAGING/PRODUCTION:
1. git pull (gets new migration files)
2. npx prisma migrate deploy
   → Reads prisma/migrations/ directory
   → Applies only unapplied migrations (tracked in _prisma_migrations table)
```

### Anatomy of a Migration

```sql
-- prisma/migrations/20260601000000_add_notes_to_jobs/migration.sql
-- AlterTable
ALTER TABLE "jobs" ADD COLUMN "notes" TEXT;

-- CreateIndex
CREATE INDEX "jobs_user_id_idx" ON "jobs"("user_id");
```

Each migration has:
- A timestamp-based folder name (ensures ordering)
- A migration.sql file with the actual SQL
- A migration_lock file (ensures the schema provider — PostgreSQL — is consistent)

The `_prisma_migrations` table in the database tracks which migrations have been applied, when, and their checksums. If a migration file is modified after being applied, Prisma detects the checksum mismatch and warns you.

### Common Migration Commands

```bash
# Create and apply a new migration (development)
npx prisma migrate dev --name description_of_change

# Apply pending migrations (deployment)
npx prisma migrate deploy

# Reset database (reapply all migrations from scratch)
npx prisma migrate reset

# Generate Prisma client after schema changes
npx prisma generate

# View database in browser (Prisma Studio)
npx prisma studio
```

### Seeding

The `scripts/seed.js` file populates the database with sample data for development. It uses Prisma within a script:

```bash
node scripts/seed.js
```

The seed script typically:
1. Creates a test user (hashed password)
2. Creates 20-30 sample job applications with various statuses
3. Creates a sample resume

This gives every developer a consistent starting dataset without manually creating records.

---

## 8. Environment Configuration

### The 12-Factor Approach

Environment configuration follows the **12-Factor App** methodology:
- **Config stored in environment variables:** No hardcoded values, no environment-specific config files.
- **Strict separation of config from code:** The same codebase deploys to development, staging, and production with different config values.
- **Fail fast on missing config:** The app validates all required variables at startup and crashes with a clear error message if any are missing.

### Configuration File

```javascript
// config/environment.js
const dotenv = require('dotenv');
const path = require('path');
const Joi = require('joi');

// Load .env file (in production, env vars are set by the platform)
dotenv.config({ path: path.resolve(__dirname, '../../.env') });

// Define expected environment variables with types
const envSchema = Joi.object({
  NODE_ENV: Joi.string()
    .valid('development', 'production', 'test')
    .default('development'),

  PORT: Joi.number().default(3000),

  DATABASE_URL: Joi.string()
    .uri({ scheme: ['postgresql', 'postgres'] })
    .required()
    .description('PostgreSQL connection string'),

  JWT_SECRET: Joi.string()
    .min(32)
    .required()
    .description('At least 32 characters for JWT signing'),

  JWT_EXPIRES_IN: Joi.string()
    .default('15m'),

  JWT_REFRESH_SECRET: Joi.string()
    .min(32)
    .required(),

  JWT_REFRESH_EXPIRES_IN: Joi.string()
    .default('7d'),

  UPLOAD_DIR: Joi.string()
    .default('uploads'),

  MAX_FILE_SIZE: Joi.number()
    .default(5 * 1024 * 1024),

  CORS_ORIGIN: Joi.string()
    .default('*'),

  LOG_LEVEL: Joi.string()
    .valid('error', 'warn', 'info', 'debug')
    .default('info'),
}).unknown(); // Allow other env vars (system vars like PATH)

const { error, value: env } = envSchema.validate(process.env);

if (error) {
  throw new Error(
    `Environment validation failed:\n${error.details.map(d => `  - ${d.message}`).join('\n')}`
  );
}

module.exports = env;
```

This file:
1. Loads `.env` using dotenv (development only — production env vars are set by the platform)
2. Defines a Joi schema with types, defaults, descriptions, and validation rules
3. Validates `process.env` against the schema
4. Throws a detailed error if validation fails
5. Exports the validated config object

### .env.example

```env
# .env.example — Copy to .env and fill in values

# Application
NODE_ENV=development
PORT=3000

# Database
DATABASE_URL=postgresql://jobpilot:jobpilot_pass@localhost:5432/jobpilot

# JWT
JWT_SECRET=change-this-to-a-random-64-char-string
JWT_EXPIRES_IN=15m
JWT_REFRESH_SECRET=change-this-to-another-random-64-char-string
JWT_REFRESH_EXPIRES_IN=7d

# Uploads
UPLOAD_DIR=uploads
MAX_FILE_SIZE=5242880

# CORS
CORS_ORIGIN=http://localhost:3000

# Logging
LOG_LEVEL=info
```

The `.env.example` file is committed to Git. It documents every required variable with dummy/default values. Developers copy it to `.env` and fill in real values. The `.env` file is in `.gitignore` — secrets are never committed.

### Development vs Production

| Aspect | Development | Production |
|--------|-------------|------------|
| Env source | `.env` file | Platform env vars (Heroku, Railway, Docker) |
| NODE_ENV | `development` | `production` |
| Error stacks | Included in responses | Hidden |
| Database | Local Docker PostgreSQL | Managed PostgreSQL (Railway, AWS RDS) |
| File storage | Local `uploads/` | S3 or cloud storage |
| Logging | Console with colors | Structured JSON to stdout |

The key principle: the same code runs in both environments. Only the environment variables differ. This is why `config/environment.js` reads from `.env` only as a fallback — in production, the platform sets env vars natively, and dotenv is a no-op.
