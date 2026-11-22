import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { careerInsightsSchema } from "../src/services/ai/schemas/career-insights.schema";

describe("Career Insights Output Schema Unit Tests", () => {
  it("careerInsightsSchema parses complete valid scoring payload", () => {
    const valid = {
      careerScore: 82,
      interviewReadiness: 75,
      resumeStrength: 90,
      jobMatchQuality: 85,
      applicationSuccessRate: 60,
      skillGaps: ["Distributed Caching", "GraphQL"],
      recommendations: [
        "Include production caching examples in resume",
        "Practice system design behavioral scenarios",
      ],
    };
    const parsed = careerInsightsSchema.safeParse(valid);
    assert.equal(parsed.success, true);
  });

  it("careerInsightsSchema rejects scores above 100", () => {
    const invalid = {
      careerScore: 105,
      interviewReadiness: 75,
      resumeStrength: 90,
      jobMatchQuality: 85,
      applicationSuccessRate: 60,
      skillGaps: [],
      recommendations: [],
    };
    assert.equal(careerInsightsSchema.safeParse(invalid).success, false);
  });

  it("careerInsightsSchema rejects more than 5 recommendations", () => {
    const tooManyRecs = {
      careerScore: 80,
      interviewReadiness: 70,
      resumeStrength: 80,
      jobMatchQuality: 80,
      applicationSuccessRate: 50,
      skillGaps: [],
      recommendations: ["1", "2", "3", "4", "5", "6"],
    };
    assert.equal(careerInsightsSchema.safeParse(tooManyRecs).success, false);
  });
});
