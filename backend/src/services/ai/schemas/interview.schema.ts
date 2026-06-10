import { z } from 'zod';

const questionSchema = z.object({
  question: z.string(),
  category: z.enum(['HR', 'TECHNICAL', 'BEHAVIORAL', 'FOLLOW_UP']),
  difficulty: z.enum(['EASY', 'MEDIUM', 'HARD']),
  expectedPoints: z.array(z.string()),
});

export const interviewQuestionsSchema = z.object({
  hrQuestions: z.array(questionSchema).length(5),
  technicalQuestions: z.array(questionSchema).length(5),
  behavioralQuestions: z.array(questionSchema).length(5),
  followUpQuestions: z.array(questionSchema).length(3),
});

export type InterviewQuestionsOutput = z.infer<typeof interviewQuestionsSchema>;
