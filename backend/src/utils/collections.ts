/**
 * Builds a frequency map of items keyed by `keyFn`.
 */
export const countBy = <T>(items: readonly T[], keyFn: (item: T) => string): Record<string, number> => {
  const counts: Record<string, number> = {};
  for (const item of items) {
    const key = keyFn(item);
    counts[key] = (counts[key] || 0) + 1;
  }
  return counts;
};

/**
 * Returns the given value as an array of strings, dropping non-string
 * elements, or an empty array when the value is not an array.
 */
export const stringList = (value: unknown): string[] =>
  Array.isArray(value) ? value.filter((item): item is string => typeof item === "string") : [];