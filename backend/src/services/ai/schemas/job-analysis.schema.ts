import { z } from 'zod';

export const jobAnalysisSchema = z.object({
  requiredSkills: z.array(z.string()),
  preferredSkills: z.array(z.string()),
  experienceRequired: z.string(),
  missingSkills: z.array(z.string()),
  resumeMatchScore: z.number().min(0).max(100).nullable(),
  recommendedChanges: z.array(z.string()),
});

export type JobAnalysisOutput = z.infer<typeof jobAnalysisSchema>;
