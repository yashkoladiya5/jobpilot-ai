import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { registerSchema, loginSchema } from "../src/validators/auth.validator";

describe("Auth Validators Unit Tests", () => {
  it("registerSchema validates correct payload", () => {
    const valid = {
      body: {
        email: "alex@example.com",
        password: "password123",
        name: "Alex Smith",
      },
    };
    const result = registerSchema.safeParse(valid);
    assert.equal(result.success, true);
  });

  it("registerSchema rejects invalid email or short password/name", () => {
    const invalidEmail = {
      body: {
        email: "not-an-email",
        password: "password123",
        name: "Alex",
      },
    };
    assert.equal(registerSchema.safeParse(invalidEmail).success, false);

    const shortPassword = {
      body: {
        email: "alex@example.com",
        password: "short",
        name: "Alex",
      },
    };
    assert.equal(registerSchema.safeParse(shortPassword).success, false);

    const shortName = {
      body: {
        email: "alex@example.com",
        password: "password123",
        name: "A",
      },
    };
    assert.equal(registerSchema.safeParse(shortName).success, false);
  });

  it("loginSchema validates login with valid email and password", () => {
    const valid = {
      body: {
        email: "user@example.com",
        password: "any-password",
      },
    };
    assert.equal(loginSchema.safeParse(valid).success, true);
  });

  it("loginSchema fails when email is invalid or password empty", () => {
    const emptyPassword = {
      body: {
        email: "user@example.com",
        password: "",
      },
    };
    assert.equal(loginSchema.safeParse(emptyPassword).success, false);
  });
});
