import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { coverLetterSchema } from "../src/services/ai/schemas/cover-letter.schema";
import { resumeMatchingSchema } from "../src/services/ai/schemas/resume-matching.schema";
import { jobAnalysisSchema } from "../src/services/ai/schemas/job-analysis.schema";

describe("AI Output Schemas Unit Tests", () => {
  it("coverLetterSchema parses valid generated response", () => {
    const valid = {
      coverLetter: "Dear Hiring Manager,\n\nI am thrilled to submit my application for the Software Engineer role. I bring deep expertise in Flutter and cloud architectures with high-impact production apps.\n\nSincerely,\nAlex",
      keyHighlights: ["Flutter Architecture", "Cloud Integrations"],
      tone: "professional",
      wordCount: 220,
    };
    const parsed = coverLetterSchema.safeParse(valid);
    assert.equal(parsed.success, true);
  });

  it("coverLetterSchema rejects letters shorter than 100 characters", () => {
    const tooShort = {
      coverLetter: "Too short",
      keyHighlights: [],
      tone: "professional",
      wordCount: 2,
    };
    assert.equal(coverLetterSchema.safeParse(tooShort).success, false);
  });

  it("resumeMatchingSchema validates score range 0 to 100", () => {
    const valid = {
      matchScore: 88,
      matchedSkills: ["Flutter", "Dart", "CI/CD"],
      missingSkills: ["Kubernetes"],
      priorityImprovements: ["Add containerization experience"],
      interviewRiskAreas: ["Scaling systems"],
      overallAssessment: "Strong match for mobile engineering team.",
    };
    assert.equal(resumeMatchingSchema.safeParse(valid).success, true);

    const outOfBounds = { ...valid, matchScore: 105 };
    assert.equal(resumeMatchingSchema.safeParse(outOfBounds).success, false);
  });

  it("jobAnalysisSchema parses required skills and allows nullable resumeMatchScore", () => {
    const valid = {
      requiredSkills: ["TypeScript", "Node.js"],
      preferredSkills: ["GraphQL"],
      experienceRequired: "3+ years",
      missingSkills: [],
      resumeMatchScore: null,
      recommendedChanges: ["Highlight backend REST experience"],
    };
    assert.equal(jobAnalysisSchema.safeParse(valid).success, true);
  });
});
