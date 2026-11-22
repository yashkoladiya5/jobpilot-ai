import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { resumeAnalysisSchema } from "../src/services/ai/schemas/resume-analysis.schema";

describe("Resume Analysis Output Schema Unit Tests", () => {
  it("resumeAnalysisSchema parses complete ATS analysis payload", () => {
    const valid = {
      atsScore: 92,
      strengths: ["Clean typography", "Action verbs with quantitative metrics"],
      weaknesses: ["Missing cloud certifications"],
      missingKeywords: ["AWS Lambda", "Terraform"],
      suggestions: ["Add link to GitHub portfolio"],
      experienceSummary: "5+ years developing mobile applications in Flutter and native iOS.",
      skillsSummary: "Dart, Flutter, State Management, REST APIs, Git.",
      recruiterFeedback: "Candidate shows strong experience in scalable client applications.",
    };

    const parsed = resumeAnalysisSchema.safeParse(valid);
    assert.equal(parsed.success, true);
  });

  it("resumeAnalysisSchema enforces atsScore bounds between 0 and 100", () => {
    const negativeScore = {
      atsScore: -5,
      strengths: [],
      weaknesses: [],
      missingKeywords: [],
      suggestions: [],
      experienceSummary: "summary",
      skillsSummary: "skills",
      recruiterFeedback: "feedback",
    };
    assert.equal(resumeAnalysisSchema.safeParse(negativeScore).success, false);

    const overScore = {
      ...negativeScore,
      atsScore: 105,
    };
    assert.equal(resumeAnalysisSchema.safeParse(overScore).success, false);
  });

  it("resumeAnalysisSchema rejects arrays exceeding 5 items for strengths, weaknesses, or suggestions", () => {
    const tooManyStrengths = {
      atsScore: 85,
      strengths: ["1", "2", "3", "4", "5", "6"],
      weaknesses: [],
      missingKeywords: [],
      suggestions: [],
      experienceSummary: "summary",
      skillsSummary: "skills",
      recruiterFeedback: "feedback",
    };
    assert.equal(resumeAnalysisSchema.safeParse(tooManyStrengths).success, false);
  });
});
