export function buildCoverLetterPrompt(resumeText: string, jobDescription: string, tone: string): string {
  return `You are an expert professional cover letter writer with extensive experience crafting compelling, tailored cover letters for top companies. Write a cover letter based on the following resume and job description.

TONE: ${tone}

Respond ONLY with valid JSON matching this exact schema:
{
  "coverLetter": "string (the full cover letter text, properly formatted with paragraphs, 250-400 words)",
  "keyHighlights": ["string array of up to 5 key skills or experiences that directly match the job requirements"],
  "tone": "${tone}",
  "wordCount": "number (actual word count of the cover letter)"
}

The cover letter should:
- Open with a strong hook that connects your experience to the role
- Highlight 2-3 specific relevant achievements from the resume
- Demonstrate knowledge of the company and role
- Close with a confident call to action
- Match the requested tone throughout

RESUME:
${resumeText}

JOB DESCRIPTION:
${jobDescription}

Remember: ONLY return valid JSON. No markdown, no explanations, no other text.`;
}
