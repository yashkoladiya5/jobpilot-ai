export interface CareerDataInput {
  totalApplications: number;
  applicationsByStatus: { status: string; count: number }[];
  recentApplications: number; // last 7 days
  interviewsThisMonth: number;
  offersThisMonth: number;
  rejectionRate: number;
  totalResumes: number;
  analyzedResumes: number;
  averageAtsScore: number | null;
  matchedJobsCount: number;
  averageMatchScore: number | null;
  completedInterviews: number;
  averageInterviewScore: number | null;
}

export function buildCareerInsightsPrompt(data: CareerDataInput): string {
  return `You are an expert career analytics AI. Analyze the following career data and provide actionable insights.

Respond ONLY with valid JSON matching this exact schema:
{
  "careerScore": number (0-100),
  "interviewReadiness": number (0-100),
  "resumeStrength": number (0-100),
  "jobMatchQuality": number (0-100),
  "applicationSuccessRate": number (0-100),
  "skillGaps": string[],
  "recommendations": string[] (max 5 actionable recommendations)
}

CAREER DATA:
${JSON.stringify(data, null, 2)}

Remember: ONLY return valid JSON. No markdown, no explanations, no other text.`;
}
