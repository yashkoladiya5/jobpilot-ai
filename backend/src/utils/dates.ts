/**
 * Returns a Date object `days` in the past (local time-based).
 */
export const daysAgo = (days: number): Date => {
  const date = new Date();
  date.setDate(date.getDate() - days);
  return date;
};

/**
 * Formats a Date as a YYYY-MM-DD key for grouping metrics by day.
 */
export const dateKey = (date: Date): string => date.toISOString().slice(0, 10);

/**
 * Formats a Date as a YYYY-MM key for grouping metrics by month.
 */
export const monthKey = (date: Date): string => date.toISOString().slice(0, 7);

const MS_PER_DAY = 1000 * 60 * 60 * 24;

/**
 * Returns the number of whole days between `from` and `to` (inclusive of
 * partial days), floored and clamped to a minimum of 1.
 */
export const elapsedDays = (from: Date, to: Date = new Date()): number =>
  Math.max(1, Math.floor((to.getTime() - from.getTime()) / MS_PER_DAY));