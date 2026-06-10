import prisma from "../../config/prisma";
import { generateStructuredResponse } from "./gemini.client";
import { buildCareerInsightsPrompt, CareerDataInput } from "./prompts/career-insights.prompt";
import { careerInsightsSchema, CareerInsightsOutput } from "./schemas/career-insights.schema";
import { ApiError } from "../../utils/ApiError";
import { startOfWeek } from "date-fns";

export class CareerInsightsService {
  async computeInsights(userId: string): Promise<CareerInsightsOutput> {
    const totalApplications = await prisma.jobApplication.count({ where: { userId } });

    const applicationsByStatusRaw = await prisma.jobApplication.groupBy({
      by: ["status"],
      where: { userId },
      _count: true,
    });

    const applicationsByStatus = applicationsByStatusRaw.map(s => ({
      status: s.status,
      count: s._count,
    }));

    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    const recentApplications = await prisma.jobApplication.count({
      where: { userId, appliedDate: { gte: oneWeekAgo } },
    });

    const firstOfMonth = new Date();
    firstOfMonth.setDate(1);

    const interviewsThisMonth = await prisma.jobApplication.count({
      where: { userId, status: "INTERVIEW", updatedAt: { gte: firstOfMonth } },
    });

    const offersThisMonth = await prisma.jobApplication.count({
      where: { userId, status: "OFFER", updatedAt: { gte: firstOfMonth } },
    });

    const rejected = await prisma.jobApplication.count({
      where: { userId, status: "REJECTED" },
    });

    const rejectionRate = totalApplications > 0 ? Math.round((rejected / totalApplications) * 100) : 0;

    const totalResumes = await prisma.resume.count({ where: { userId } });

    const analyzedResumes = await prisma.resumeAnalysis.count({
      where: { userId, status: "COMPLETED" },
    });

    const avgAts = await prisma.resumeAnalysis.aggregate({
      where: { userId, status: "COMPLETED", atsScore: { not: null } },
      _avg: { atsScore: true },
    });

    const completedInterviews = await prisma.interviewSession.count({
      where: { userId, status: "COMPLETED" },
    });

    const avgInterviewScore = await prisma.interviewResult.aggregate({
      where: { session: { userId } },
      _avg: { overallScore: true },
    });

    const matchedJobs = await prisma.jobAnalysis.count({
      where: { userId, status: "COMPLETED", resumeMatchScore: { not: null } },
    });

    const avgMatch = await prisma.jobAnalysis.aggregate({
      where: { userId, status: "COMPLETED", resumeMatchScore: { not: null } },
      _avg: { resumeMatchScore: true },
    });

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

    const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 });

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
