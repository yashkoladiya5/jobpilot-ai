import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import path from "node:path";
import { readTextFileSafely, readTextFileOrThrow } from "../src/utils/fs";
import { ApiError } from "../src/utils/ApiError";

describe("FS Utilities Unit Tests", () => {
  const packageJsonPath = path.resolve(__dirname, "../package.json");
  const nonexistentPath = path.resolve(__dirname, "../nonexistent-file.xyz");

  it("readTextFileSafely returns file content when file exists", async () => {
    const content = await readTextFileSafely(packageJsonPath, "fallback");
    assert.ok(typeof content === "string");
    assert.ok(content.includes("jobpilot-ai-backend"));
  });

  it("readTextFileSafely returns fallback value when file does not exist", async () => {
    const fallback = { fallback: true };
    const result = await readTextFileSafely(nonexistentPath, fallback);
    assert.deepEqual(result, fallback);
  });

  it("readTextFileOrThrow reads existing file successfully", async () => {
    const content = await readTextFileOrThrow(packageJsonPath, "Cannot read file");
    assert.ok(content.includes("jobpilot-ai-backend"));
  });

  it("readTextFileOrThrow throws 400 ApiError on missing file", async () => {
    await assert.rejects(
      async () => {
        await readTextFileOrThrow(nonexistentPath, "File could not be found");
      },
      (err: unknown) => err instanceof ApiError && err.statusCode === 400 && err.message === "File could not be found"
    );
  });
});
