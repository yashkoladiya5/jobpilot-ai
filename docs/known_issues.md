# Known Issues

## Current Issues
- Backend requires PostgreSQL running locally or via Docker to run Prisma migrations
- Flutter app needs `flutter pub get` run with Flutter SDK installed
- File upload controller/service not yet implemented (placeholder 501 response)

## By Severity

### Critical
*None*

### High
*None*

### Medium
*None*

### Low
- Multer v1 has known vulnerabilities; should upgrade to v2 before production
- `uuid` v10 has deprecation warning for CommonJS; should use `uuid` v11 before production

## Resolved

### Resolved during Milestone 1
- Added missing `url` field to Prisma datasource block (was causing P1012 validation error)
- Removed `schema` property from datasource block (not supported in Prisma v5)
- Fixed JWT `expiresIn` type incompatibility with newer @types/jsonwebtoken (StringValue branded type)
- Fixed auth middleware from using `throw` to `next(error)` pattern for Express error propagation
