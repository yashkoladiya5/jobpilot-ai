import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { daysAgo, dateKey, monthKey, elapsedDays, MS_PER_DAY } from "../src/utils/dates";

describe("Date Utilities Unit Tests", () => {
  it("dateKey formats Date to YYYY-MM-DD", () => {
    const d = new Date("2025-05-15T12:00:00.000Z");
    assert.equal(dateKey(d), "2025-05-15");
  });

  it("monthKey formats Date to YYYY-MM", () => {
    const d = new Date("2025-05-15T12:00:00.000Z");
    assert.equal(monthKey(d), "2025-05");
  });

  it("daysAgo returns a date subtracted by the given number of days", () => {
    const now = new Date();
    const past = daysAgo(10);
    const diff = Math.round((now.getTime() - past.getTime()) / MS_PER_DAY);
    assert.equal(diff, 10);
  });

  it("elapsedDays returns floored days between two dates with minimum 1", () => {
    const from = new Date("2025-01-01T00:00:00Z");
    const to = new Date("2025-01-06T12:00:00Z");
    assert.equal(elapsedDays(from, to), 5);

    // Identical dates should clamp to minimum 1
    assert.equal(elapsedDays(from, from), 1);
  });
});
