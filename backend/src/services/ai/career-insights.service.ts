import prisma from "../../config/prisma";
import { generateStructuredResponse } from "./gemini.client";
import { buildCareerInsightsPrompt, CareerDataInput } from "./prompts/career-insights.prompt";
import { careerInsightsSchema, CareerInsightsOutput } from "./schemas/career-insights.schema";
import { ApiError } from "../../utils/ApiError";
import { startOfWeek } from "date-fns";

/**
 * Service responsible for aggregating user career data and leveraging AI
 * to generate personalized career insights and recommendations.
 */
export class CareerInsightsService {
  async computeInsights(userId: string, options?: { forceRefresh?: boolean }): Promise<CareerInsightsOutput> {
    const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });
    
    if (!options?.forceRefresh) {
      const existing = await prisma.careerInsight.findFirst({
        where: { userId, weekStart },
      });
      if (existing) {
        return {
          careerScore: existing.careerScore ?? 0,
          interviewReadiness: existing.interviewReadiness ?? 0,
          resumeStrength: existing.resumeStrength ?? 0,
          jobMatchQuality: existing.jobMatchQuality ?? 0,
          applicationSuccessRate: existing.applicationSuccessRate ?? 0,
          skillGaps: Array.isArray(existing.skillGaps)
            ? existing.skillGaps.filter((gap): gap is string => typeof gap === "string")
            : [],
          recommendations: Array.isArray(existing.recommendations)
            ? existing.recommendations.filter((rec): rec is string => typeof rec === "string")
            : [],
        };
      }
    }

    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    const firstOfMonth = new Date();
    firstOfMonth.setDate(1);

    const [
      totalApplications,
      applicationsByStatusRaw,
      recentApplications,
      interviewsThisMonth,
      offersThisMonth,
      rejected,
      totalResumes,
      analyzedResumes,
      avgAts,
      completedInterviews,
      avgInterviewScore,
      matchedJobs,
      avgMatch,
    ] = await Promise.all([
      prisma.jobApplication.count({ where: { userId } }),

      prisma.jobApplication.groupBy({
        by: ["status"],
        where: { userId },
        _count: true,
      }),

      prisma.jobApplication.count({
        where: { userId, appliedDate: { gte: oneWeekAgo } },
      }),

      prisma.jobApplication.count({
        where: { userId, status: "INTERVIEW", updatedAt: { gte: firstOfMonth } },
      }),

      prisma.jobApplication.count({
        where: { userId, status: "OFFER", updatedAt: { gte: firstOfMonth } },
      }),

      prisma.jobApplication.count({
        where: { userId, status: "REJECTED" },
      }),

      prisma.resume.count({ where: { userId } }),

      prisma.resumeAnalysis.count({
        where: { userId, status: "COMPLETED" },
      }),

      prisma.resumeAnalysis.aggregate({
        where: { userId, status: "COMPLETED", atsScore: { not: null } },
        _avg: { atsScore: true },
      }),

      prisma.interviewSession.count({
        where: { userId, status: "COMPLETED" },
      }),

      prisma.interviewResult.aggregate({
        where: { session: { userId } },
        _avg: { overallScore: true },
      }),

      prisma.jobAnalysis.count({
        where: { userId, status: "COMPLETED", resumeMatchScore: { not: null } },
      }),

      prisma.jobAnalysis.aggregate({
        where: { userId, status: "COMPLETED", resumeMatchScore: { not: null } },
        _avg: { resumeMatchScore: true },
      }),
    ]);

    const applicationsByStatus = applicationsByStatusRaw.map(s => ({
      status: s.status,
      count: s._count,
    }));

    const rejectionRate = totalApplications > 0 ? Math.round((rejected / totalApplications) * 100) : 0;

    const careerData: CareerDataInput = {
      totalApplications,
      applicationsByStatus,
      recentApplications,
      interviewsThisMonth,
      offersThisMonth,
      rejectionRate,
      totalResumes,
      analyzedResumes,
      averageAtsScore: avgAts._avg.atsScore || null,
      matchedJobsCount: matchedJobs,
      averageMatchScore: avgMatch._avg.resumeMatchScore || null,
      completedInterviews,
      averageInterviewScore: avgInterviewScore._avg.overallScore || null,
    };

    const prompt = buildCareerInsightsPrompt(careerData);
    const response = await generateStructuredResponse(prompt, careerInsightsSchema);

    if (!response.success || !response.data) {
      return {
        careerScore: this.computeFallbackScore(careerData),
        interviewReadiness: completedInterviews > 0 ? Math.min(100, completedInterviews * 20) : 20,
        resumeStrength: avgAts._avg.atsScore || 50,
        jobMatchQuality: avgMatch._avg.resumeMatchScore || 50,
        applicationSuccessRate: totalApplications > 0 ? Math.round((offersThisMonth / totalApplications) * 100) : 0,
        skillGaps: [],
        recommendations: ["Upload and analyze your resume to get personalized recommendations."],
      };
    }

    await prisma.careerInsight.create({
      data: {
        userId,
        careerScore: response.data.careerScore,
        interviewReadiness: response.data.interviewReadiness,
        resumeStrength: response.data.resumeStrength,
        jobMatchQuality: response.data.jobMatchQuality,
        applicationSuccessRate: response.data.applicationSuccessRate,
        skillGaps: response.data.skillGaps,
        recommendations: response.data.recommendations,
        insightsData: careerData as any,
        weekStart,
      },
    });

    return response.data;
  }

  async getLatestInsights(userId: string) {
    const latest = await prisma.careerInsight.findFirst({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });

    if (!latest) {
      return null;
    }

    return latest;
  }

  async getInsightsHistory(userId: string) {
    return prisma.careerInsight.findMany({
      where: { userId },
      orderBy: { weekStart: "desc" },
      take: 12,
    });
  }

  async deleteInsightsHistory(userId: string) {
    const deleted = await prisma.careerInsight.deleteMany({
      where: { userId },
    });

    return { count: deleted.count };
  }

  private computeFallbackScore(data: CareerDataInput): number {
    let score = 50;
    if (data.totalApplications > 0) score += 5;
    if (data.interviewsThisMonth > 0) score += 10;
    if (data.offersThisMonth > 0) score += 15;
    if (data.analyzedResumes > 0) score += 10;
    if (data.averageAtsScore && data.averageAtsScore > 70) score += 10;
    if (data.averageMatchScore && data.averageMatchScore > 70) score += 10;
    return Math.min(100, Math.max(0, score));
  }
}

export const careerInsightsService = new CareerInsightsService();
