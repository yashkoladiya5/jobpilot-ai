import { z } from 'zod';

export const resumeMatchingSchema = z.object({
  matchScore: z.number().min(0).max(100),
  matchedSkills: z.array(z.string()),
  missingSkills: z.array(z.string()),
  priorityImprovements: z.array(z.string()).max(5),
  interviewRiskAreas: z.array(z.string()),
  overallAssessment: z.string(),
});

export type ResumeMatchingOutput = z.infer<typeof resumeMatchingSchema>;
