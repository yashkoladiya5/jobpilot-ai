export function buildResumeMatchingPrompt(resumeText: string, jobDescription: string): string {
  return `You are an expert resume-job matching algorithm. Compare the provided resume against the job description and produce a detailed match analysis.

Respond ONLY with valid JSON matching this exact schema:
{
  "matchScore": number (0-100),
  "matchedSkills": string[],
  "missingSkills": string[],
  "priorityImprovements": string[] (max 5, ordered by importance),
  "interviewRiskAreas": string[] (topics the candidate should prepare for),
  "overallAssessment": string (2-3 sentences)
}

RESUME:
${resumeText}

JOB DESCRIPTION:
${jobDescription}

Remember: ONLY return valid JSON. No markdown, no explanations, no other text.`;
}
