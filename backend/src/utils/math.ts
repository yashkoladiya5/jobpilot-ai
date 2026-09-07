/**
 * Clamps a numeric value into the inclusive [min, max] range.
 */
export const clampNumber = (value: number, min: number, max: number): number =>
  Math.min(max, Math.max(min, value));