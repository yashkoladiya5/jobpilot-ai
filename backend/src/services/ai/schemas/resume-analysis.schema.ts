import { z } from 'zod';

export const resumeAnalysisSchema = z.object({
  atsScore: z.number().min(0).max(100),
  strengths: z.array(z.string()).max(5),
  weaknesses: z.array(z.string()).max(5),
  missingKeywords: z.array(z.string()),
  suggestions: z.array(z.string()).max(5),
  experienceSummary: z.string(),
  skillsSummary: z.string(),
  recruiterFeedback: z.string(),
});

export type ResumeAnalysisOutput = z.infer<typeof resumeAnalysisSchema>;
