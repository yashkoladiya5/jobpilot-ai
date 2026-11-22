import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { createJobSchema, updateJobSchema } from "../src/validators/job.validator";
import { ApplicationStatus } from "@prisma/client";

describe("Job Validators Unit Tests", () => {
  it("createJobSchema validates a complete job application payload", () => {
    const valid = {
      body: {
        companyName: "Google",
        role: "Senior Flutter Engineer",
        jobUrl: "https://careers.google.com/jobs/123",
        salaryRange: "$150k - $180k",
        location: "Mountain View, CA",
        status: ApplicationStatus.APPLIED,
        notes: "Referral via LinkedIn",
      },
    };
    const result = createJobSchema.safeParse(valid);
    assert.equal(result.success, true);
  });

  it("createJobSchema rejects empty companyName or missing role", () => {
    const invalid = {
      body: {
        companyName: "",
        role: "",
      },
    };
    const result = createJobSchema.safeParse(invalid);
    assert.equal(result.success, false);
  });

  it("updateJobSchema allows partial updates", () => {
    const partialUpdate = {
      body: {
        status: ApplicationStatus.INTERVIEW,
        notes: "Phone screen scheduled for next Tuesday",
      },
    };
    const result = updateJobSchema.safeParse(partialUpdate);
    assert.equal(result.success, true);
  });

  it("jobStatusEnum rejects invalid application status strings", () => {
    const invalidStatus = {
      body: {
        status: "INVALID_STATUS_NAME",
      },
    };
    const result = updateJobSchema.safeParse(invalidStatus);
    assert.equal(result.success, false);
  });
});
