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