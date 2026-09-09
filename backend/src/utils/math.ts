/**
 * Clamps a numeric value into the inclusive [min, max] range.
 */
export const clampNumber = (value: number, min: number, max: number): number =>
  Math.min(max, Math.max(min, value));

/**
 * Returns a uniformly distributed random integer in the inclusive [min, max] range.
 */
export const randInt = (min: number, max: number): number =>
  Math.floor(Math.random() * (max - min + 1)) + min;

/**
 * Returns `part / total` expressed as a whole-number percentage.
 * A zero (or negative) total yields 0 to avoid division by zero.
 */
export const percentOf = (part: number, total: number): number =>
  total > 0 ? Math.round((part / total) * 100) : 0;