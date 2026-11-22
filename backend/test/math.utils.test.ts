import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { clampNumber, randInt, percentOf } from "../src/utils/math";

describe("Math Utilities Unit Tests", () => {
  it("clampNumber bounds value within min and max", () => {
    assert.equal(clampNumber(50, 0, 100), 50);
    assert.equal(clampNumber(-10, 0, 100), 0);
    assert.equal(clampNumber(150, 0, 100), 100);
  });

  it("randInt generates integers within specified range", () => {
    for (let i = 0; i < 20; i++) {
      const val = randInt(5, 15);
      assert.ok(val >= 5 && val <= 15, `Expected ${val} between 5 and 15`);
      assert.equal(val, Math.floor(val));
    }
  });

  it("percentOf calculates whole-number percentage and handles zero division", () => {
    assert.equal(percentOf(25, 100), 25);
    assert.equal(percentOf(1, 3), 33);
    assert.equal(percentOf(2, 3), 67);
    assert.equal(percentOf(5, 0), 0);
    assert.equal(percentOf(5, -10), 0);
  });
});
