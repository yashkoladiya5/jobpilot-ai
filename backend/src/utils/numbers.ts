import { ApiError } from "./ApiError";

/**
 * Parses an unknown (usually query/body) value as a positive integer.
 * Returns the provided fallback (often a default, or undefined) when the
 * value is absent.
 * Returns NaN for values that cannot be parsed as a number.
 */
export const parsePositiveInt = (value: unknown, fallback: number | undefined): number | undefined => {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  return parseInt(String(value), 10);
};

/**
 * Parses an unknown (usually query/body) value as a non-negative integer.
 * Returns the provided fallback when the value is absent, not a number, or negative.
 */
export const parseIntWithDefault = (value: unknown, fallback: number): number => {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  const parsed = parseInt(String(value), 10);
  return Number.isNaN(parsed) || parsed < 0 ? fallback : parsed;
};

/**
 * Parses a query value as a positive integer, throwing a 400 API error
 * when the value (or its fallback) is not a positive integer.
 */
export const parsePositiveIntOrThrow = (
  value: unknown,
  fallback: number,
  message: string
): number => {
  const parsed = parsePositiveInt(value, fallback);
  if (typeof parsed !== "number" || isNaN(parsed) || parsed < 1) {
    throw ApiError.badRequest(message);
  }
  return parsed;
};