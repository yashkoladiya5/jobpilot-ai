import { z } from 'zod';

export const careerInsightsSchema = z.object({
  careerScore: z.number().min(0).max(100),
  interviewReadiness: z.number().min(0).max(100),
  resumeStrength: z.number().min(0).max(100),
  jobMatchQuality: z.number().min(0).max(100),
  applicationSuccessRate: z.number().min(0).max(100),
  skillGaps: z.array(z.string()),
  recommendations: z.array(z.string()).max(5),
});

export type CareerInsightsOutput = z.infer<typeof careerInsightsSchema>;
