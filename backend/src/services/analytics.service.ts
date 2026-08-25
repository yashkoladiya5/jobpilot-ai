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

  async getRejectionAnalytics(userId: string) {
    const rejectedApplications = await prisma.jobApplication.findMany({
      where: { userId, status: "REJECTED" },
      orderBy: { updatedAt: "desc" },
    });

    const totalRejections = rejectedApplications.length;
    
    // Group rejections by role
    const roleCounts: Record<string, number> = {};
    for (const app of rejectedApplications) {
      const role = app.role.toLowerCase();
      roleCounts[role] = (roleCounts[role] || 0) + 1;
    }

    const topRejectedRoles = Object.entries(roleCounts)
      .map(([role, count]) => ({ role, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);

    return {
      totalRejections,
      topRejectedRoles,
      recentRejections: rejectedApplications.slice(0, 5).map(app => ({
        company: app.companyName,
        role: app.role,
        date: app.updatedAt,
      })),
    };
  }

  async getOfferAnalytics(userId: string) {
    const offerApplications = await prisma.jobApplication.findMany({
      where: { userId, status: "OFFER" },
      orderBy: { updatedAt: "desc" },
    });

    const totalOffers = offerApplications.length;

    const offerCompanies = offerApplications.map(app => app.companyName);

    return {
      totalOffers,
      offerCompanies,
      recentOffers: offerApplications.slice(0, 5).map(app => ({
        company: app.companyName,
        role: app.role,
        date: app.updatedAt,
      })),
    };
  }

  async getInterviewAnalytics(userId: string) {
    const interviewApplications = await prisma.jobApplication.findMany({
      where: { userId, status: "INTERVIEW" },
      orderBy: { updatedAt: "desc" },
    });

    const totalInterviews = interviewApplications.length;
    const interviewCompanies = interviewApplications.map(app => app.companyName);

    return {
      totalInterviews,
      interviewCompanies,
      recentInterviews: interviewApplications.slice(0, 5).map(app => ({
        company: app.companyName,
        role: app.role,
        date: app.updatedAt,
      })),
    };
  }

  async getWeeklyActivitySummary(userId: string) {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    const applicationsThisWeek = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: oneWeekAgo },
      },
    });

    const totalApplied = applicationsThisWeek.length;
    const interviewCount = applicationsThisWeek.filter(app => app.status === "INTERVIEW").length;
    const offerCount = applicationsThisWeek.filter(app => app.status === "OFFER").length;
    const rejectionCount = applicationsThisWeek.filter(app => app.status === "REJECTED").length;

    return {
      timeframe: "Last 7 days",
      totalApplied,
      interviewCount,
      offerCount,
      rejectionCount,
      activeCompanies: [...new Set(applicationsThisWeek.map(app => app.companyName))],
    };
  }

  async getResumeAnalytics(userId: string) {
    const resumes = await prisma.resume.findMany({
      where: { userId },
      include: {
        analyses: true,
      },
    });

    const totalResumes = resumes.length;
    let totalScore = 0;
    let analyzedResumes = 0;

    resumes.forEach(resume => {
      if (resume.analyses && resume.analyses.length > 0) {
        // Find the latest analysis score
        const latestAnalysis = resume.analyses.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())[0];
        if (latestAnalysis.overallScore) {
          totalScore += latestAnalysis.overallScore;
          analyzedResumes++;
        }
      }
    });

    const averageResumeScore = analyzedResumes > 0 ? Math.round(totalScore / analyzedResumes) : 0;

    return {
      totalResumes,
      analyzedResumes,
      averageResumeScore,
      needsImprovement: averageResumeScore < 70 && analyzedResumes > 0,
      recentlyUpdated: resumes.slice(0, 3).map(r => ({
        id: r.id,
        name: r.fileName,
        updatedAt: r.updatedAt
      }))
    };
  }

  async getInterviewTrends(userId: string) {
    const interviewResults = await prisma.interviewResult.findMany({
      where: { session: { userId } },
      orderBy: { createdAt: "asc" },
      include: { session: { select: { completedAt: true } } }
    });

    if (interviewResults.length === 0) {
      return { trend: [], improvementRate: 0 };
    }

    // Group by month
    const monthlyScores: Record<string, { sum: number, count: number }> = {};
    
    for (const result of interviewResults) {
      if (!result.session.completedAt) continue;
      
      const monthYear = result.session.completedAt.toISOString().slice(0, 7); // YYYY-MM
      if (!monthlyScores[monthYear]) {
        monthlyScores[monthYear] = { sum: 0, count: 0 };
      }
      monthlyScores[monthYear].sum += (result.overallScore || 0);
      monthlyScores[monthYear].count++;
    }

    const trend = Object.entries(monthlyScores)
      .sort((a, b) => a[0].localeCompare(b[0]))
      .map(([month, data]) => ({
        month,
        averageScore: Math.round(data.sum / data.count)
      }));

    let improvementRate = 0;
    if (trend.length >= 2) {
      const firstScore = trend[0].averageScore;
      const latestScore = trend[trend.length - 1].averageScore;
      if (firstScore > 0) {
        improvementRate = Math.round(((latestScore - firstScore) / firstScore) * 100);
      }
    }

    return { trend, improvementRate };
  }

  async getJobSourceAnalytics(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId, jobUrl: { not: null } },
      select: { jobUrl: true, status: true },
    });

    const sourceStats: Record<string, { total: number; interviews: number; offers: number }> = {};

    for (const app of applications) {
      if (!app.jobUrl) continue;
      
      let source = "Other";
      const url = app.jobUrl.toLowerCase();
      
      if (url.includes("linkedin.com")) source = "LinkedIn";
      else if (url.includes("indeed.com")) source = "Indeed";
      else if (url.includes("glassdoor.com")) source = "Glassdoor";
      else if (url.includes("greenhouse.io")) source = "Greenhouse";
      else if (url.includes("lever.co")) source = "Lever";

      if (!sourceStats[source]) {
        sourceStats[source] = { total: 0, interviews: 0, offers: 0 };
      }

      sourceStats[source].total++;
      if (app.status === "INTERVIEW") sourceStats[source].interviews++;
      if (app.status === "OFFER") sourceStats[source].offers++;
    }

    const analytics = Object.entries(sourceStats).map(([source, stats]) => ({
      source,
      totalApplications: stats.total,
      interviewRate: stats.total > 0 ? Math.round((stats.interviews / stats.total) * 100) : 0,
      offerRate: stats.total > 0 ? Math.round((stats.offers / stats.total) * 100) : 0,
    })).sort((a, b) => b.totalApplications - a.totalApplications);

    return analytics;
  }

  async getSkillsGapAnalytics(userId: string) {
    // In a real application, we'd extract preferred skills from all job descriptions
    // the user applied to and compare them to the user's parsed resume skills.
    
    // For now, we mock the skills gap based on typical tech roles
    const industryDemand = [
      { skill: "Kubernetes", demand: 85, userHas: false },
      { skill: "GraphQL", demand: 75, userHas: false },
      { skill: "TypeScript", demand: 95, userHas: true },
      { skill: "React", demand: 90, userHas: true },
      { skill: "Go", demand: 60, userHas: false },
    ];
    
    const missingSkills = industryDemand
      .filter(s => !s.userHas)
      .sort((a, b) => b.demand - a.demand);
      
    const presentSkills = industryDemand
      .filter(s => s.userHas)
      .sort((a, b) => b.demand - a.demand);

    return {
      topMissingSkills: missingSkills.slice(0, 5).map(s => ({ skill: s.skill, importance: s.demand })),
      topPresentSkills: presentSkills.slice(0, 5).map(s => ({ skill: s.skill, importance: s.demand })),
      recommendation: missingSkills.length > 0 
        ? `Consider learning ${missingSkills[0].skill} as it appears frequently in your target roles.` 
        : "Your skill set is highly aligned with your target roles!"
    };
  }

  async getOfferNegotiationInsights(userId: string) {
    const offerApplications = await prisma.jobApplication.findMany({
      where: { userId, status: "OFFER" },
      orderBy: { updatedAt: "desc" },
    });

    if (offerApplications.length === 0) {
      return {
        hasOffers: false,
        message: "You don't have any recorded offers yet. Keep applying!",
        insights: null
      };
    }

    const averageSalaryString = offerApplications
      .map(app => app.salaryRange)
      .filter(Boolean)
      .join(", ");
      
    // Mock parsing salary ranges and giving negotiation insights
    const mockAverageOfferValue = 120000;
    const marketAverage = 115000;
    
    return {
      hasOffers: true,
      totalOffers: offerApplications.length,
      averageOfferValue: `$${mockAverageOfferValue.toLocaleString()}`,
      marketAverage: `$${marketAverage.toLocaleString()}`,
      negotiationLeverage: offerApplications.length > 1 ? "High" : "Medium",
      topAdvice: offerApplications.length > 1 
        ? "You have multiple offers! Use them to negotiate higher base pay or sign-on bonuses."
        : "Always negotiate your first offer. Ask for 5-10% more base or additional equity.",
      recentOffers: offerApplications.slice(0, 3).map(app => ({
        company: app.companyName,
        role: app.role,
        salaryRange: app.salaryRange || "Not specified"
      }))
    };
  }
}
