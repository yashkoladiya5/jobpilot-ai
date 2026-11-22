import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { parsePositiveInt, parseIntWithDefault, parsePositiveIntOrThrow } from "../src/utils/numbers";
import { ApiError } from "../src/utils/ApiError";

describe("Numbers Utilities Unit Tests", () => {
  it("parsePositiveInt parses positive integer strings and returns fallback for empty", () => {
    assert.equal(parsePositiveInt("42", undefined), 42);
    assert.equal(parsePositiveInt("100", 10), 100);
    assert.equal(parsePositiveInt("", 5), 5);
    assert.equal(parsePositiveInt(null, 10), 10);
    assert.equal(parsePositiveInt(undefined, undefined), undefined);
    assert.ok(isNaN(parsePositiveInt("abc", undefined)!));
    assert.ok(isNaN(parsePositiveInt("12abc", undefined)!));
    assert.ok(isNaN(parsePositiveInt("-5", undefined)!));
  });

  it("parseIntWithDefault provides fallback on invalid or negative numbers", () => {
    assert.equal(parseIntWithDefault("15", 10), 15);
    assert.equal(parseIntWithDefault("0", 10), 0);
    assert.equal(parseIntWithDefault("-5", 10), 10);
    assert.equal(parseIntWithDefault("invalid", 10), 10);
    assert.equal(parseIntWithDefault(null, 20), 20);
  });

  it("parsePositiveIntOrThrow returns valid integer or throws badRequest ApiError", () => {
    assert.equal(parsePositiveIntOrThrow("25", 10, "Invalid limit"), 25);
    assert.equal(parsePositiveIntOrThrow("", 10, "Invalid limit"), 10);

    assert.throws(
      () => parsePositiveIntOrThrow("0", 0, "Limit must be at least 1"),
      (err: unknown) => err instanceof ApiError && err.statusCode === 400
    );

    assert.throws(
      () => parsePositiveIntOrThrow("not-a-number", 1, "Limit must be a number"),
      (err: unknown) => err instanceof ApiError && err.statusCode === 400
    );
  });
});
