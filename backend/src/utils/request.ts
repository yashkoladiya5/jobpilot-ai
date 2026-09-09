import { ApiError } from "./ApiError";

/**
 * Ensures a request body value is an array of strings, throwing a 400 otherwise.
 */
export const requireStringArray = (value: unknown, message: string): string[] => {
  if (!Array.isArray(value) || value.some((item) => typeof item !== "string")) {
    throw ApiError.badRequest(message);
  }
  return value;
};