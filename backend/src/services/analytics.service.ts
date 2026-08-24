import prisma from "../config/prisma";

/**
 * Service for calculating advanced insights and aggregated metrics
 * used in the user's pipeline and timeline analytics dashboards.
 */
export class AnalyticsService {
  async getPipelineAnalytics(userId: string) {
    // Retrieve all job applications for the user, ordered by newest first
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });

    const totalApplications = applications.length;

    const statusCounts: Record<string, number> = {};
    for (const app of applications) {
      statusCounts[app.status] = (statusCounts[app.status] || 0) + 1;
    }

    const byStatus = Object.entries(statusCounts).map(([status, count]) => ({
      status,
      count,
      percentage: totalApplications > 0 ? Math.round((count / totalApplications) * 100) : 0,
    }));

    const applied = statusCounts["APPLIED"] || 0;
    const interview = statusCounts["INTERVIEW"] || 0;
    const offer = statusCounts["OFFER"] || 0;

    const conversionRates = {
      appliedToInterview: applied > 0 ? Math.round((interview / applied) * 100) : 0,
      interviewToOffer: interview > 0 ? Math.round((offer / interview) * 100) : 0,
      overallSuccessRate: totalApplications > 0 ? Math.round((offer / totalApplications) * 100) : 0,
    };

    const now = new Date();
    let totalDays = 0;
    let countWithDates = 0;
    for (const app of applications) {
      totalDays += (now.getTime() - app.appliedDate.getTime()) / (1000 * 60 * 60 * 24);
      countWithDates++;
    }
    const averageDaysInPipeline =
      countWithDates > 0 ? Number((totalDays / countWithDates).toFixed(1)) : 0;

    const companyCounts: Record<string, number> = {};
    for (const app of applications) {
      companyCounts[app.companyName] = (companyCounts[app.companyName] || 0) + 1;
    }
    const topCompanies = Object.entries(companyCounts)
      .map(([company, count]) => ({ company, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 10);

    const recentActivity = applications.slice(0, 20).map((app) => ({
      date: app.updatedAt.toISOString(),
      action: app.status,
      company: app.companyName,
      role: app.role,
    }));

    const monthlyTrend: { month: string; applications: number; interviews: number; offers: number }[] =
      [];
    const monthMap: Record<string, { applications: number; interviews: number; offers: number }> = {};
    for (const app of applications) {
      const month = app.appliedDate.toISOString().slice(0, 7);
      if (!monthMap[month]) {
        monthMap[month] = { applications: 0, interviews: 0, offers: 0 };
      }
      monthMap[month].applications++;
      if (app.status === "INTERVIEW") monthMap[month].interviews++;
      if (app.status === "OFFER") monthMap[month].offers++;
    }
    for (const [month, data] of Object.entries(monthMap).sort((a, b) => a[0].localeCompare(b[0]))) {
      monthlyTrend.push({ month, ...data });
    }

    return {
      totalApplications,
      byStatus,
      conversionRates,
      averageDaysInPipeline,
      topCompanies,
      recentActivity,
      monthlyTrend,
    };
  }

  async getTimelineData(userId: string) {
    const twelveWeeksAgo = new Date();
    twelveWeeksAgo.setDate(twelveWeeksAgo.getDate() - 84);

    const applications = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: twelveWeeksAgo },
      },
      orderBy: { createdAt: "asc" },
    });

    const weekMap: Record<string, { count: number; statuses: Record<string, number> }> = {};

    for (let i = 0; i < 12; i++) {
      const weekStart = new Date();
      weekStart.setDate(weekStart.getDate() - (11 - i) * 7);
      const weekKey = weekStart.toISOString().slice(0, 10);
      weekMap[weekKey] = { count: 0, statuses: {} };
    }

    for (const app of applications) {
      const appDate = app.createdAt;
      const daysSinceEpoch = Math.floor(appDate.getTime() / (1000 * 60 * 60 * 24));
      const weekStartDay = daysSinceEpoch - (daysSinceEpoch % 7);
      const weekStart = new Date(weekStartDay * 1000 * 60 * 60 * 24);
      const weekKey = weekStart.toISOString().slice(0, 10);

      if (!weekMap[weekKey]) {
        weekMap[weekKey] = { count: 0, statuses: {} };
      }
      weekMap[weekKey].count++;
      weekMap[weekKey].statuses[app.status] = (weekMap[weekKey].statuses[app.status] || 0) + 1;
    }

    const timeline = Object.entries(weekMap)
      .sort((a, b) => a[0].localeCompare(b[0]))
      .map(([week, data]) => ({
        week,
        count: data.count,
        statuses: data.statuses,
      }));

    return timeline;
  }

  async getSkillMatchAnalytics(userId: string) {
    // Basic mock implementation for skill match insights based on user profile
    const mockSkillData = [
      { skill: "React", matchScore: 90, frequency: 15 },
      { skill: "Node.js", matchScore: 85, frequency: 12 },
      { skill: "TypeScript", matchScore: 95, frequency: 18 },
      { skill: "AWS", matchScore: 70, frequency: 8 },
      { skill: "Docker", matchScore: 65, frequency: 5 },
    ];
    
    return {
      averageMatchScore: 81,
      topMatchedSkills: mockSkillData.slice(0, 3),
      skillsToImprove: mockSkillData.slice(3),
    };
  }
}
