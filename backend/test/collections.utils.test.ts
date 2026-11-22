import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { countBy, stringList } from "../src/utils/collections";

describe("Collections Utilities Unit Tests", () => {
  it("countBy aggregates elements into frequency record based on key function", () => {
    const list = [
      { status: "APPLIED" },
      { status: "INTERVIEW" },
      { status: "APPLIED" },
      { status: "OFFER" },
    ];
    const grouped = countBy(list, (item) => item.status);
    assert.deepEqual(grouped, {
      APPLIED: 2,
      INTERVIEW: 1,
      OFFER: 1,
    });
  });

  it("stringList filters arrays preserving only string values", () => {
    assert.deepEqual(stringList(["TypeScript", 123, "Flutter", null, undefined, true]), [
      "TypeScript",
      "Flutter",
    ]);
  });

  it("stringList handles non-array inputs cleanly by returning empty array", () => {
    assert.deepEqual(stringList(null), []);
    assert.deepEqual(stringList(undefined), []);
    assert.deepEqual(stringList("not an array"), []);
    assert.deepEqual(stringList({ foo: "bar" }), []);
  });
});
