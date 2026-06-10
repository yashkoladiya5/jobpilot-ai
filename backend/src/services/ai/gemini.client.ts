import { GoogleGenerativeAI } from '@google/generative-ai';
import { geminiConfig } from './gemini.config';
import { ApiError } from '../../utils/ApiError';

interface GeminiResponse<T> {
  success: boolean;
  data?: T;
  rawResponse?: string;
  error?: string;
}

export async function generateStructuredResponse<T>(
  prompt: string,
  schema: { parse: (data: unknown) => T },
  retries = geminiConfig.maxRetries
): Promise<GeminiResponse<T>> {
  if (!geminiConfig.apiKey) {
    return { success: false, error: 'GEMINI_API_KEY is not configured' };
  }

  let lastError: string = '';

  for (let attempt = 0; attempt <= retries; attempt++) {
    try {
      const genAI = new GoogleGenerativeAI(geminiConfig.apiKey);
      const model = genAI.getGenerativeModel({
        model: geminiConfig.model,
        generationConfig: geminiConfig.generationConfig,
        safetySettings: geminiConfig.safetySettings as any,
      });

      const result = await model.generateContent(prompt);
      const response = result.response;
      const text = response.text();

      // Extract JSON from response (handle markdown code blocks)
      const jsonStr = extractJson(text);
      if (!jsonStr) {
        lastError = 'No JSON found in Gemini response';
        if (attempt < retries) {
          await delay(geminiConfig.retryDelayMs * (attempt + 1));
          continue;
        }
        return { success: false, error: lastError, rawResponse: text };
      }

      const parsed = JSON.parse(jsonStr);
      const validated = schema.parse(parsed);
      return { success: true, data: validated, rawResponse: text };
    } catch (error: any) {
      lastError = error.message || 'Unknown Gemini error';
      if (attempt < retries) {
        await delay(geminiConfig.retryDelayMs * (attempt + 1));
        continue;
      }
    }
  }

  return { success: false, error: lastError };
}

function extractJson(text: string): string | null {
  // Try to extract from markdown code block first
  const codeBlockMatch = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  if (codeBlockMatch) {
    return codeBlockMatch[1].trim();
  }
  // Try to find JSON object directly
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (jsonMatch) {
    return jsonMatch[0];
  }
  return null;
}

function delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
