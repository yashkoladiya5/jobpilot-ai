import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { interviewQuestionsSchema } from "../src/services/ai/schemas/interview.schema";

describe("Interview Questions Output Schema Unit Tests", () => {
  const sampleQuestion = (category: 'HR' | 'TECHNICAL' | 'BEHAVIORAL' | 'SITUATIONAL' | 'FOLLOW_UP') => ({
    question: "Explain state management tradeoffs.",
    category,
    difficulty: "MEDIUM" as const,
    expectedPoints: ["Reactivity", "Testability", "Boilerplate"],
  });

  it("interviewQuestionsSchema validates payload with expected category question counts", () => {
    const valid = {
      hrQuestions: Array(5).fill(sampleQuestion("HR")),
      technicalQuestions: Array(5).fill(sampleQuestion("TECHNICAL")),
      behavioralQuestions: Array(5).fill(sampleQuestion("BEHAVIORAL")),
      situationalQuestions: Array(5).fill(sampleQuestion("SITUATIONAL")),
      followUpQuestions: Array(3).fill(sampleQuestion("FOLLOW_UP")),
    };

    const parsed = interviewQuestionsSchema.safeParse(valid);
    assert.equal(parsed.success, true);
  });

  it("interviewQuestionsSchema rejects arrays with incorrect question lengths", () => {
    const invalidCount = {
      hrQuestions: Array(4).fill(sampleQuestion("HR")), // Expected exactly 5
      technicalQuestions: Array(5).fill(sampleQuestion("TECHNICAL")),
      behavioralQuestions: Array(5).fill(sampleQuestion("BEHAVIORAL")),
      situationalQuestions: Array(5).fill(sampleQuestion("SITUATIONAL")),
      followUpQuestions: Array(3).fill(sampleQuestion("FOLLOW_UP")),
    };

    assert.equal(interviewQuestionsSchema.safeParse(invalidCount).success, false);
  });

  it("interviewQuestionsSchema rejects invalid categories", () => {
    const invalidCategory = {
      hrQuestions: Array(5).fill({
        ...sampleQuestion("HR"),
        category: "INVALID_CAT",
      }),
      technicalQuestions: Array(5).fill(sampleQuestion("TECHNICAL")),
      behavioralQuestions: Array(5).fill(sampleQuestion("BEHAVIORAL")),
      situationalQuestions: Array(5).fill(sampleQuestion("SITUATIONAL")),
      followUpQuestions: Array(3).fill(sampleQuestion("FOLLOW_UP")),
    };

    assert.equal(interviewQuestionsSchema.safeParse(invalidCategory).success, false);
  });
});
