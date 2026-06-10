export function buildInterviewQuestionsPrompt(
  jobDescription: string,
  resumeText?: string
): string {
  let prompt = `You are an expert interview coach. Based on the job description below, generate comprehensive interview questions.

Respond ONLY with valid JSON matching this exact schema:
{
  "hrQuestions": { "question": string, "category": "HR", "difficulty": "EASY" | "MEDIUM" | "HARD", "expectedPoints": string[] }[] (5 questions),
  "technicalQuestions": { "question": string, "category": "TECHNICAL", "difficulty": "EASY" | "MEDIUM" | "HARD", "expectedPoints": string[] }[] (5 questions),
  "behavioralQuestions": { "question": string, "category": "BEHAVIORAL", "difficulty": "EASY" | "MEDIUM" | "HARD", "expectedPoints": string[] }[] (5 questions),
  "followUpQuestions": { "question": string, "category": "FOLLOW_UP", "difficulty": "EASY" | "MEDIUM" | "HARD", "expectedPoints": string[] }[] (3 questions)
}

JOB DESCRIPTION:
${jobDescription}`;

  if (resumeText) {
    prompt += `\n\nCandidate's Resume:
${resumeText}

Tailor questions to this candidate's specific background and the job requirements.`;
  }

  prompt += `\n\nRemember: ONLY return valid JSON. No markdown, no explanations, no other text.`;
  return prompt;
}
