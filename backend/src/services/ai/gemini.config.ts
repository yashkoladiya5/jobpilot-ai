import dotenv from 'dotenv';
import { HarmBlockThreshold, HarmCategory } from '@google/generative-ai';
dotenv.config();

export const geminiConfig = {
  apiKey: process.env.GEMINI_API_KEY || '',
  model: 'gemini-2.0-flash',
  generationConfig: {
    temperature: 0.2,
    topP: 0.8,
    topK: 40,
    maxOutputTokens: 8192,
  },
  safetySettings: [
    { category: HarmCategory.HARM_CATEGORY_HARASSMENT, threshold: HarmBlockThreshold.BLOCK_NONE },
    { category: HarmCategory.HARM_CATEGORY_HATE_SPEECH, threshold: HarmBlockThreshold.BLOCK_NONE },
    { category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT, threshold: HarmBlockThreshold.BLOCK_NONE },
    { category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT, threshold: HarmBlockThreshold.BLOCK_NONE },
  ],
  maxRetries: 2,
  retryDelayMs: 1000,
  timeoutMs: 30000,
};
