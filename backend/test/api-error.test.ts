import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { ApiError } from "../src/utils/ApiError";

describe("ApiError Class Unit Tests", () => {
  it("constructor properly initializes status code, message, and operational flag", () => {
    const error = new ApiError(400, "Validation failed", true);
    assert.equal(error.statusCode, 400);
    assert.equal(error.message, "Validation failed");
    assert.equal(error.isOperational, true);
    assert.ok(error instanceof Error);
    assert.ok(error instanceof ApiError);
  });

  it("factory methods instantiate standard HTTP status codes correctly", () => {
    const badReq = ApiError.badRequest("Invalid input");
    assert.equal(badReq.statusCode, 400);
    assert.equal(badReq.message, "Invalid input");

    const unauth = ApiError.unauthorized("Missing token");
    assert.equal(unauth.statusCode, 401);

    const forbidden = ApiError.forbidden("Access denied");
    assert.equal(forbidden.statusCode, 403);

    const notFound = ApiError.notFound("Resource not found");
    assert.equal(notFound.statusCode, 404);

    const unprocessable = ApiError.unprocessableEntity("Semantic error");
    assert.equal(unprocessable.statusCode, 422);

    const rateLimit = ApiError.tooManyRequests("Rate limit reached");
    assert.equal(rateLimit.statusCode, 429);

    const serverErr = ApiError.internal("Unexpected error");
    assert.equal(serverErr.statusCode, 500);
  });
});
