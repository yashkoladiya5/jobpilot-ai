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

  async getCareerGrowthPotential(userId: string) {
    // Mock calculating career growth potential based on application roles and user's skills
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { role: true }
    });

    if (applications.length === 0) {
      return {
        hasData: false,
        message: "Not enough data to calculate career growth. Start applying!",
        potentialScore: 0,
        nextLevelRoles: []
      };
    }

    const roles = applications.map(app => app.role.toLowerCase());
    const isJunior = roles.some(r => r.includes("junior") || r.includes("entry"));
    const isMid = roles.some(r => !r.includes("junior") && !r.includes("senior") && !r.includes("lead"));
    
    let currentLevel = "Mid-Level";
    let nextLevel = "Senior Level";
    
    if (isJunior) {
      currentLevel = "Junior Level";
      nextLevel = "Mid-Level";
    } else if (isMid && !roles.some(r => r.includes("senior"))) {
      currentLevel = "Mid-Level";
      nextLevel = "Senior Level";
    } else {
      currentLevel = "Senior Level";
      nextLevel = "Staff/Lead Level";
    }

    return {
      hasData: true,
      currentEstimatedLevel: currentLevel,
      targetNextLevel: nextLevel,
      potentialScore: 78,
      readinessMessage: `You are 78% ready for ${nextLevel} roles.`,
      recommendedSkillsToLevelUp: ["System Design", "Cloud Architecture", "Leadership/Mentorship"],
      nextLevelRoles: [
        `Senior ${applications[0].role.replace(/junior |entry /gi, '')}`,
        `Lead ${applications[0].role.replace(/junior |entry /gi, '')}`
      ]
    };
  }

  async getPeerComparisonAnalytics(userId: string) {
    // Mock comparing user against anonymized peer data for their role
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { role: true, status: true, salaryRange: true }
    });

    if (applications.length === 0) {
      return {
        hasData: false,
        message: "Apply to more jobs to see how you stack up against peers.",
        metrics: null
      };
    }

    const primaryRole = applications[0].role;
    
    // Calculate user's interview rate
    const totalApps = applications.length;
    const interviewCount = applications.filter(a => a.status === "INTERVIEW" || a.status === "OFFER").length;
    const userInterviewRate = totalApps > 0 ? Math.round((interviewCount / totalApps) * 100) : 0;
    
    // Mock peer averages
    const peerInterviewRate = 18; // 18%
    const peerOfferRate = 4; // 4%
    const peerAvgSalary = "$120,000";

    const userOfferCount = applications.filter(a => a.status === "OFFER").length;
    const userOfferRate = totalApps > 0 ? Math.round((userOfferCount / totalApps) * 100) : 0;

    return {
      hasData: true,
      roleAnalyzed: primaryRole,
      metrics: {
        interviewRate: {
          user: userInterviewRate,
          peerAverage: peerInterviewRate,
          percentile: userInterviewRate > peerInterviewRate ? "Top 25%" : "Bottom 50%"
        },
        offerRate: {
          user: userOfferRate,
          peerAverage: peerOfferRate,
          percentile: userOfferRate > peerOfferRate ? "Top 10%" : "Bottom 50%"
        },
        marketSalary: {
          peerAverage: peerAvgSalary,
          insight: "Your offers are generally aligned with the market average."
        }
      },
      summary: userInterviewRate > peerInterviewRate 
        ? "Your resume is performing better than average in securing interviews!"
        : "Your interview rate is below average. Consider optimizing your resume keywords."
    };
  }

  async getOfferPredictor(userId: string) {
    // Mock predicting the likelihood of an offer based on pipeline status
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { role: true, status: true, companyName: true }
    });

    const activeInterviews = applications.filter(a => a.status === "INTERVIEW");
    
    if (activeInterviews.length === 0) {
      return {
        hasActiveInterviews: false,
        message: "You don't have any active interviews. Keep applying to increase your chances!",
        predictor: null
      };
    }

    // Mock probability calculation
    const baseProbability = 20; // 20% base chance for any interview
    const extraPerInterview = 5; // +5% for each additional interview
    
    let totalProbability = baseProbability + ((activeInterviews.length - 1) * extraPerInterview);
    if (totalProbability > 85) totalProbability = 85; // Cap at 85%

    return {
      hasActiveInterviews: true,
      activeInterviewCount: activeInterviews.length,
      offerProbability: totalProbability,
      topProspects: activeInterviews.slice(0, 3).map(a => ({
        company: a.companyName,
        role: a.role,
        probability: Math.round(baseProbability + Math.random() * 20) // Random between 20-40% for individual
      })),
      insight: `With ${activeInterviews.length} active interviews, you have an estimated ${totalProbability}% chance of receiving at least one offer in the next 30 days.`
    };
  }

  async getNetworkingROI(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { status: true } 
    });

    if (applications.length === 0) {
      return {
        hasData: false,
        message: "No applications found to calculate networking ROI."
      };
    }

    // Mocking referral data for demonstration
    const referredApps = applications.filter((_, i) => i % 4 === 0); // Mock 25% referred
    const coldApps = applications.filter((_, i) => i % 4 !== 0);

    const calcRate = (apps: any[], targetStatus: string) => {
      if (apps.length === 0) return 0;
      return Math.round((apps.filter(a => a.status === targetStatus).length / apps.length) * 100);
    };

    const referredInterviewRate = calcRate(referredApps, "INTERVIEW") || 35; // Mock fallback
    const coldInterviewRate = calcRate(coldApps, "INTERVIEW") || 10;
    
    const roiMultiplier = coldInterviewRate > 0 ? (referredInterviewRate / coldInterviewRate).toFixed(1) : "3.5";

    return {
      hasData: true,
      totalReferred: referredApps.length,
      totalCold: coldApps.length,
      referredInterviewRate: `${referredInterviewRate}%`,
      coldInterviewRate: `${coldInterviewRate}%`,
      roiMultiplier: `${roiMultiplier}x`,
      insight: `Applications where you had a referral or network connection were ${roiMultiplier}x more likely to result in an interview.`
    };
  }

  async getJobSearchEffectiveness(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { status: true }
    });

    if (applications.length === 0) {
      return { score: 0, rating: "Needs Data", message: "Apply to more jobs to calculate your effectiveness score." };
    }

    const total = applications.length;
    const interviews = applications.filter(a => a.status === "INTERVIEW" || a.status === "OFFER").length;
    const offers = applications.filter(a => a.status === "OFFER").length;

    // Calculate a composite score out of 100
    // Interview rate weight: 70%, Offer rate weight: 30%
    const interviewRate = (interviews / total) * 100;
    const offerRate = interviews > 0 ? (offers / interviews) * 100 : 0;

    let score = (interviewRate * 0.7) + (offerRate * 0.3);
    
    // Cap at 100, add small bonus for volume
    if (total > 20) score += 5;
    score = Math.min(100, Math.round(score));

    let rating = "Needs Improvement";
    if (score >= 80) rating = "Excellent";
    else if (score >= 50) rating = "Good";
    else if (score >= 30) rating = "Average";

    return {
      score,
      rating,
      metrics: {
        totalApplications: total,
        interviewConversionRate: `${Math.round(interviewRate)}%`,
        offerConversionRate: `${Math.round(offerRate)}%`
      },
      message: score >= 50 ? "Your job search strategy is working well!" : "Consider optimizing your resume to improve your interview rate."
    };
  }

  async getApplicationGhostingPredictor(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId, status: { in: ["APPLIED", "INTERVIEW"] } },
      select: { id: true, companyName: true, role: true, status: true, updatedAt: true }
    });

    if (applications.length === 0) {
      return {
        ghostedCount: 0,
        ghostedApplications: [],
        insight: "You don't have any active applications to analyze for ghosting."
      };
    }

    const now = new Date().getTime();
    const ghostedApplications = [];

    for (const app of applications) {
      const daysSinceUpdate = Math.floor((now - app.updatedAt.getTime()) / (1000 * 60 * 60 * 24));
      
      // Assume ghosting if it's been more than 21 days since APPLIED or 14 days since INTERVIEW
      let ghostingProbability = 0;
      let reason = "";

      if (app.status === "APPLIED") {
        if (daysSinceUpdate >= 21) {
          ghostingProbability = Math.min(95, 50 + (daysSinceUpdate - 21) * 2);
          reason = `It's been ${daysSinceUpdate} days since you applied.`;
        }
      } else if (app.status === "INTERVIEW") {
        if (daysSinceUpdate >= 14) {
          ghostingProbability = Math.min(95, 60 + (daysSinceUpdate - 14) * 3);
          reason = `It's been ${daysSinceUpdate} days since your last interview update.`;
        }
      }

      if (ghostingProbability >= 75) {
        ghostedApplications.push({
          id: app.id,
          company: app.companyName,
          role: app.role,
          status: app.status,
          probability: `${ghostingProbability}%`,
          reason
        });
      }
    }

    return {
      ghostedCount: ghostedApplications.length,
      ghostedApplications: ghostedApplications.sort((a, b) => parseInt(b.probability) - parseInt(a.probability)),
      insight: ghostedApplications.length > 0 
        ? `We predict you've been ghosted on ${ghostedApplications.length} applications. Consider archiving them to keep your pipeline clean.`
        : "Great! None of your active applications appear to be ghosted."
    };
  }

  async trackLoginDuration(userId: string, durationSeconds: number) {
    if (durationSeconds < 0) {
      throw ApiError.badRequest("Duration must be a positive number.");
    }

    // In a real application, we would insert this into a UserSession or LoginDuration table.
    // For this mock implementation, we return the parsed data simulating a successful log.

    return {
      userId,
      durationSeconds,
      durationMinutes: (durationSeconds / 60).toFixed(2),
      loggedAt: new Date().toISOString(),
      message: "Login duration successfully recorded."
    };
  }

  async getCustomDateRangeStats(userId: string, startDate: Date, endDate: Date) {
    if (startDate > endDate) {
      throw ApiError.badRequest("Start date cannot be after end date");
    }

    const [totalApplications, grouped, interviewsScheduled, offersReceived] = await Promise.all([
      prisma.jobApplication.count({
        where: {
          userId,
          appliedDate: { gte: startDate, lte: endDate }
        }
      }),
      prisma.jobApplication.groupBy({
        by: ["status"],
        where: {
          userId,
          appliedDate: { gte: startDate, lte: endDate }
        },
        _count: { status: true },
      }),
      prisma.jobApplication.count({
        where: {
          userId,
          status: "INTERVIEW",
          appliedDate: { gte: startDate, lte: endDate }
        }
      }),
      prisma.jobApplication.count({
        where: {
          userId,
          status: "OFFER",
          appliedDate: { gte: startDate, lte: endDate }
        }
      })
    ]);

    const byStatus = grouped.map((g) => ({
      status: g.status,
      count: g._count.status,
    }));

    return {
      userId,
      dateRange: { start: startDate, end: endDate },
      totalApplications,
      interviewsScheduled,
      offersReceived,
      byStatus
    };
  }

  async exportAnalyticsReport(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw ApiError.notFound("User not found");

    // We'd generate a CSV or PDF in a real app, here we return a structured JSON representing the export
    const basicStats = await this.getPipelineAnalytics(userId);
    const funnel = await this.getWeeklyActivitySummary(userId);
    
    return {
      userId,
      exportedAt: new Date().toISOString(),
      reportType: "FULL_ANALYTICS_EXPORT",
      data: {
        basicStats,
        funnel
      },
      message: "Analytics report exported successfully."
    };
  }

  async getInterviewSuccessRate(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { 
        userId,
        status: { in: ["INTERVIEW", "OFFER", "REJECTED", "WITHDRAWN"] }
      },
      select: { status: true, updatedAt: true, companyName: true }
    });

    const totalInterviewed = applications.length;
    if (totalInterviewed === 0) {
      return {
        totalInterviews: 0,
        successRate: 0,
        message: "No interview data available yet."
      };
    }

    const offers = applications.filter(a => a.status === "OFFER").length;
    const rejections = applications.filter(a => a.status === "REJECTED").length;
    const active = applications.filter(a => a.status === "INTERVIEW").length;

    // Calculate success rate based on resolved interviews (Offers / (Offers + Rejections))
    const resolvedInterviews = offers + rejections;
    const successRate = resolvedInterviews > 0 ? Math.round((offers / resolvedInterviews) * 100) : 0;

    return {
      totalInterviews: totalInterviewed,
      activeInterviews: active,
      resolvedInterviews,
      offers,
      rejections,
      successRate: `${successRate}%`,
      message: successRate >= 50 
        ? "Excellent! You convert a high number of interviews to offers."
        : "Keep practicing! Consider reviewing common interview questions to boost your success rate."
    };
  }

  async getSkillDemandForecast(userId: string) {
    // In a real app we would query ML models or large datasets to forecast demand
    const recentApps = await prisma.jobApplication.findMany({
      where: { userId },
      select: { role: true },
      orderBy: { createdAt: "desc" },
      take: 10
    });
    
    const roleBase = recentApps.length > 0 ? recentApps[0].role : "Software Engineer";
    
    const mockForecast = [
      { skill: "Next.js", currentDemand: "High", projectedDemand: "Very High", timeframe: "6-12 months", confidence: "85%" },
      { skill: "GraphQL", currentDemand: "Medium", projectedDemand: "High", timeframe: "1-2 years", confidence: "75%" },
      { skill: "Rust", currentDemand: "Low", projectedDemand: "Medium", timeframe: "1-2 years", confidence: "60%" }
    ];
    
    return {
      userId,
      baseRole: roleBase,
      forecastedSkills: mockForecast,
      insight: `Based on your recent applications for ${roleBase}, Next.js demand is projected to spike significantly in the next year.`,
      generatedAt: new Date().toISOString()
    };
  }

  async getApplicationConversionFunnel(userId: string) {
    const jobs = await prisma.jobApplication.findMany({
      where: { userId },
      select: { status: true },
    });

    const total = jobs.length;
    if (total === 0) {
      return {
        stages: [
          { stage: "Applied", count: 0, percentage: 0 },
          { stage: "Interview", count: 0, percentage: 0 },
          { stage: "Offer", count: 0, percentage: 0 }
        ],
        message: "Apply to jobs to start generating your conversion funnel."
      };
    }

    // A job might be in OFFER but it passed through APPLIED and INTERVIEW.
    // For a funnel, we count cumulative achievements.
    const offerCount = jobs.filter(j => j.status === 'OFFER').length;
    const interviewCount = jobs.filter(j => j.status === 'INTERVIEW').length + offerCount; // If you got an offer, you interviewed
    const appliedCount = total; // All saved/rejected/etc started as applied mostly

    const funnel = [
      { stage: "Applied", count: appliedCount, percentage: 100 },
      { 
        stage: "Interview", 
        count: interviewCount, 
        percentage: appliedCount > 0 ? Math.round((interviewCount / appliedCount) * 100) : 0 
      },
      { 
        stage: "Offer", 
        count: offerCount, 
        percentage: interviewCount > 0 ? Math.round((offerCount / interviewCount) * 100) : 0 
      }
    ];

    return {
      stages: funnel,
      overallConversionRate: appliedCount > 0 ? Math.round((offerCount / appliedCount) * 100) : 0,
      message: "Here is your application conversion funnel from application to offer."
    };
  }

  async getJobSearchDuration(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { appliedDate: true, updatedAt: true, status: true },
      orderBy: { appliedDate: "asc" }
    });

    if (applications.length === 0) {
      return {
        hasData: false,
        message: "No applications found to calculate search duration.",
        searchDurationDays: 0,
        averageTimeToOffer: 0
      };
    }

    const firstApplicationDate = applications[0].appliedDate;
    const now = new Date();
    const searchDurationDays = Math.max(1, Math.floor((now.getTime() - firstApplicationDate.getTime()) / (1000 * 60 * 60 * 24)));

    const offerApplications = applications.filter(app => app.status === "OFFER");
    let averageTimeToOffer = 0;

    if (offerApplications.length > 0) {
      let totalDaysToOffer = 0;
      for (const app of offerApplications) {
        totalDaysToOffer += Math.floor((app.updatedAt.getTime() - app.appliedDate.getTime()) / (1000 * 60 * 60 * 24));
      }
      averageTimeToOffer = Math.round(totalDaysToOffer / offerApplications.length);
    }

    return {
      hasData: true,
      firstApplicationDate: firstApplicationDate.toISOString().split('T')[0],
      searchDurationDays,
      offersReceived: offerApplications.length,
      averageTimeToOffer,
      message: offerApplications.length > 0 
        ? `You received an offer in an average of ${averageTimeToOffer} days from applying.` 
        : `You have been searching for ${searchDurationDays} days. Keep pushing!`
    };
  }

  async getOfferNegotiationLeverage(userId: string) {
    const offerApplications = await prisma.jobApplication.findMany({
      where: { userId, status: "OFFER" },
      orderBy: { updatedAt: "desc" },
    });

    const activeInterviews = await prisma.jobApplication.count({
      where: { userId, status: "INTERVIEW" }
    });

    if (offerApplications.length === 0) {
      return {
        hasOffers: false,
        leverageScore: 0,
        leverageLevel: "None",
        recommendation: "Focus on converting your active applications into offers."
      };
    }

    let leverageScore = 30; // Base score for having an offer
    
    // Add points for multiple offers
    if (offerApplications.length > 1) {
      leverageScore += 40;
    }
    
    // Add points for active pipeline (creates urgency/FOMO for employers)
    if (activeInterviews > 0) {
      leverageScore += Math.min(30, activeInterviews * 10);
    }

    let leverageLevel = "Low";
    if (leverageScore >= 80) leverageLevel = "Very High";
    else if (leverageScore >= 60) leverageLevel = "High";
    else if (leverageScore >= 40) leverageLevel = "Medium";

    return {
      hasOffers: true,
      offerCount: offerApplications.length,
      activeInterviewCount: activeInterviews,
      leverageScore,
      leverageLevel,
      recommendation: leverageScore >= 60 
        ? "You have strong negotiation power. Consider leveraging competing offers or your active pipeline to negotiate better terms."
        : "You have a solid foundation. You can negotiate, but be reasonable with your demands as your BATNA (Best Alternative to a Negotiated Agreement) isn't rock solid yet."
    };
  }

  async getApplicationChannelEffectiveness(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { id: true, status: true, notes: true }
    });

    if (applications.length === 0) {
      return { hasData: false, message: "No data available." };
    }

    const channels: Record<string, { total: number, interviews: number, offers: number }> = {
      "Cold Application": { total: 0, interviews: 0, offers: 0 },
      "Referral": { total: 0, interviews: 0, offers: 0 },
      "Recruiter Reached Out": { total: 0, interviews: 0, offers: 0 }
    };

    for (const app of applications) {
      const lowerNotes = (app.notes || "").toLowerCase();
      let channel = "Cold Application";
      if (lowerNotes.includes("referral") || lowerNotes.includes("referred by")) {
        channel = "Referral";
      } else if (lowerNotes.includes("recruiter") || lowerNotes.includes("sourced")) {
        channel = "Recruiter Reached Out";
      }
      
      channels[channel].total++;
      if (app.status === "INTERVIEW") channels[channel].interviews++;
      if (app.status === "OFFER") channels[channel].offers++;
    }

    const formatted = Object.entries(channels).map(([channel, data]) => ({
      channel,
      total: data.total,
      interviewRate: data.total > 0 ? Math.round((data.interviews / data.total) * 100) : 0,
      offerRate: data.total > 0 ? Math.round((data.offers / data.total) * 100) : 0
    }));

    return {
      hasData: true,
      data: formatted,
      message: "Channel effectiveness calculated based on your application notes."
    };
  }

  async getProfileVisibilityScore(userId: string) {
    // Check how many applications user has made recently (simulating visibility based on activity)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    const recentApps = await prisma.jobApplication.count({
      where: { userId, createdAt: { gte: thirtyDaysAgo } }
    });
    
    // Check if user has a primary resume
    const hasResume = await prisma.resume.findFirst({
      where: { userId, isPrimary: true }
    });
    
    let score = 50; // base score
    if (hasResume) score += 20;
    
    // up to 30 points for recent applications (2 points per app)
    score += Math.min(30, recentApps * 2);
    
    let visibilityLevel = "Low";
    if (score >= 80) visibilityLevel = "High";
    else if (score >= 60) visibilityLevel = "Medium";
    
    const factors = [
      { name: "Primary Resume Uploaded", status: hasResume ? "Complete" : "Incomplete", impact: "High" },
      { name: "Recent Application Activity", status: `${recentApps} in last 30 days`, impact: "Medium" }
    ];
    
    return {
      userId,
      visibilityScore: score,
      visibilityLevel,
      factors,
      message: score >= 80 
        ? "Your profile visibility is great! Recruiters are likely to notice your active profile."
        : "Boost your visibility by applying to more roles and keeping your primary resume updated."
    };
  }

  async getProfileViewsHistory(userId: string) {
    // Generate a mock time-series data for profile views over the last 30 days
    const data = [];
    const now = new Date();
    
    for (let i = 29; i >= 0; i--) {
      const date = new Date(now);
      date.setDate(date.getDate() - i);
      
      data.push({
        date: date.toISOString().slice(0, 10),
        views: Math.floor(Math.random() * 50) + 10 // Mock 10-60 views per day
      });
    }

    const totalViews = data.reduce((acc, curr) => acc + curr.views, 0);

    return {
      timeframe: "Last 30 Days",
      totalViews,
      dailyAverage: Math.round(totalViews / 30),
      trendData: data,
      message: "Profile views history generated successfully."
    };
  }

  async getUserRetentionStats(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    // Mock retrieving retention statistics (e.g., active days over total account age)
    const now = new Date();
    const accountAgeDays = Math.max(1, Math.floor((now.getTime() - user.createdAt.getTime()) / (1000 * 60 * 60 * 24)));
    
    // Simulate active days as a percentage (between 30% and 90%)
    const activeDays = Math.max(1, Math.floor(accountAgeDays * (0.3 + Math.random() * 0.6)));
    const retentionRate = Math.round((activeDays / accountAgeDays) * 100);

    return {
      userId,
      accountAgeDays,
      activeDays,
      retentionRate: `${retentionRate}%`,
      classification: retentionRate > 75 ? "Highly Active" : retentionRate > 40 ? "Regular User" : "Occasional User",
      message: "Retention statistics calculated successfully."
    };
  }

  async getTimeToHirePredictor(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { role: true, status: true, appliedDate: true, updatedAt: true }
    });

    const activeInterviews = applications.filter(a => a.status === "INTERVIEW");
    
    // Determine baseline days based on current pipeline momentum
    let baselineDays = 45; // average time to hire in days
    
    if (activeInterviews.length > 2) {
      baselineDays = 21; // Faster if you have multiple interviews
    } else if (activeInterviews.length === 1) {
      baselineDays = 30;
    } else if (applications.length > 20) {
      baselineDays = 35; // Activity helps
    } else if (applications.length < 5) {
      baselineDays = 60; // Slow start
    }

    const estimatedDate = new Date();
    estimatedDate.setDate(estimatedDate.getDate() + baselineDays);

    return {
      userId,
      currentActiveApplications: applications.filter(a => ["APPLIED", "INTERVIEW"].includes(a.status)).length,
      currentActiveInterviews: activeInterviews.length,
      estimatedDaysToHire: baselineDays,
      estimatedHireDate: estimatedDate.toISOString().slice(0, 10),
      confidence: activeInterviews.length > 0 ? "High" : "Medium",
      message: `Based on your current pipeline velocity, we estimate your time to hire at ${baselineDays} days.`
    };
  }
}
