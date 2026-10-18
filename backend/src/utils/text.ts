/**
 * Shared plain-text analysis helpers used by resume, cover letter, and
 * job-description services (word stats, sentence splitting, term frequency).
 */

export const countWords = (text: string): number =>
  text.trim().split(/\s+/).filter(Boolean).length;

export const splitSentences = (text: string): string[] =>
  text
    .split(/(?<=[.!?])\s+/)
    .map((s) => s.trim())
    .filter((s) => s.length > 0);

export const termFrequency = (text: string, limit = 10): { term: string; count: number }[] => {
  const stop = new Set([
    "the", "and", "for", "with", "that", "this", "from", "your", "you", "are",
    "have", "has", "will", "our", "we", "be", "of", "to", "in", "on", "at", "as",
  ]);

  const counts = new Map<string, number>();
  for (const raw of text.toLowerCase().split(/[^a-z0-9+#.-]+/)) {
    const term = raw.trim();
    if (term.length < 3 || stop.has(term)) continue;
    counts.set(term, (counts.get(term) ?? 0) + 1);
  }

  return Array.from(counts.entries())
    .map(([term, count]) => ({ term, count }))
    .sort((a, b) => b.count - a.count || a.term.localeCompare(b.term))
    .slice(0, limit);
};

export const averageSentenceLength = (text: string): number => {
  const sentences = splitSentences(text);
  if (sentences.length === 0) return 0;
  const total = sentences.reduce((sum, s) => sum + countWords(s), 0);
  return Math.round((total / sentences.length) * 10) / 10;
};
