export function buildResumeAnalysisPrompt(resumeText: string): string {
  return `You are an expert ATS (Applicant Tracking System) consultant and senior technical recruiter with 15+ years of experience. Analyze the following resume and provide structured feedback.

Respond ONLY with valid JSON matching this exact schema:
{
  "atsScore": number (0-100),
  "strengths": string[] (max 5),
  "weaknesses": string[] (max 5),
  "missingKeywords": string[] (common ATS keywords missing from this resume for typical roles it targets),
  "suggestions": string[] (max 5 actionable improvement suggestions),
  "experienceSummary": string (2-3 sentences summarizing work experience),
  "skillsSummary": string (1-2 sentences summarizing key skills),
  "recruiterFeedback": string (2-3 sentences of what a recruiter would think reading this resume)
}

RESUME TO ANALYZE:
${resumeText}

Remember: ONLY return valid JSON. No markdown, no explanations, no other text.`;
}
