import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { requireStringArray } from "../src/utils/request";
import { ApiError } from "../src/utils/ApiError";

describe("Request Utilities Unit Tests", () => {
  it("requireStringArray returns valid string array", () => {
    const list = ["react", "flutter", "typescript"];
    const result = requireStringArray(list, "Invalid array");
    assert.deepEqual(result, list);
  });

  it("requireStringArray accepts empty string array", () => {
    const empty: string[] = [];
    const result = requireStringArray(empty, "Invalid array");
    assert.deepEqual(result, []);
  });

  it("requireStringArray throws badRequest ApiError on non-array inputs", () => {
    assert.throws(
      () => requireStringArray("not an array", "Expected array of strings"),
      (err: unknown) => err instanceof ApiError && err.statusCode === 400
    );

    assert.throws(
      () => requireStringArray(null, "Expected array of strings"),
      (err: unknown) => err instanceof ApiError && err.statusCode === 400
    );

    assert.throws(
      () => requireStringArray([1, "flutter", 3], "Expected array of strings"),
      (err: unknown) => err instanceof ApiError && err.statusCode === 400
    );
  });
});
