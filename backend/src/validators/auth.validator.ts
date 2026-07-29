import { z } from "zod";

/**
 * Zod validation schemas for authentication endpoints.
 * Ensures incoming requests conform to required data types and constraints.
 */
/** Schema for validating user registration payloads. */
export const registerSchema = z.object({
  body: z.object({
    email: z.string().email(),
    password: z.string().min(8),
    name: z.string().min(2, "Name must be at least 2 characters"),
  }),
});

/** Schema for validating user login payloads. */
export const loginSchema = z.object({
  body: z.object({
    email: z.string().email(),
    password: z.string().min(1, "Password is required"),
  }),
});
