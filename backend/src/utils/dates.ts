/**
 * Returns a Date object `days` in the past (local time-based).
 */
export const daysAgo = (days: number): Date => {
  const date = new Date();
  date.setDate(date.getDate() - days);
  return date;
};