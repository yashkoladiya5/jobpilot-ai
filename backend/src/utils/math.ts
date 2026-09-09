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