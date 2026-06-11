export function buildJobAnalysisPrompt(jobDescription: string, resumeText?: string): string {
  let prompt = `You are an expert job description analyst and career coach. Analyze the following job description and provide structured insights.

Respond ONLY with valid JSON matching this exact schema:
{
  "requiredSkills": string[],
  "preferredSkills": string[],
  "experienceRequired": string,
  "missingSkills": string[],
  "resumeMatchScore": number (0-100, null if no resume provided),
  "recommendedChanges": string[]
}

JOB DESCRIPTION:
${jobDescription}`;

  if (resumeText) {
    prompt += `\n\nRESUME FOR MATCHING:
${resumeText}

Compare the resume against the job description to determine match score and missing skills.`;
  } else {
    prompt += `\n\nAnalyze this job description independently. Set resumeMatchScore to null since no resume is provided for comparison.`;
  }

  prompt += `\n\nRemember: ONLY return valid JSON. No markdown, no explanations, no other text.`;
  return prompt;
}
