import { z } from 'zod';

export const coverLetterSchema = z.object({
  coverLetter: z.string().min(100),
  keyHighlights: z.array(z.string()).max(5),
  tone: z.string(),
  wordCount: z.number(),
});

export type CoverLetterOutput = z.infer<typeof coverLetterSchema>;
