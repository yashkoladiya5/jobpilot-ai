import prisma from "../config/prisma";

/**
 * Provides data aggregation and statistical analysis for the user dashboard.
 */
export class DashboardService {
  async getStats(userId: string) {
    // Calculate the threshold for recent activity (last 7 days and 30 days)
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const [totalApplications, grouped, recentApplications, recentActivity, monthlyActivity, resumeCount, activeInterviews] =
      await Promise.all([
        prisma.jobApplication.count({ where: { userId } }),

        prisma.jobApplication.groupBy({
          by: ["status"],
          where: { userId },
          _count: { status: true },
        }),

        prisma.jobApplication.findMany({
          where: { userId },
          orderBy: { appliedDate: "desc" },
          take: 5,
          select: {
            id: true,
            companyName: true,
            role: true,
            status: true,
            appliedDate: true,
          },
        }),

        prisma.jobApplication.count({
          where: { userId, appliedDate: { gte: sevenDaysAgo } },
        }),
        
        prisma.jobApplication.count({
          where: { userId, appliedDate: { gte: thirtyDaysAgo } },
        }),

        prisma.resume.count({ where: { userId } }),

        prisma.jobApplication.count({
          where: { userId, status: 'INTERVIEW' },
        }),
      ]);

    const byStatus = grouped.map((g) => ({
      status: g.status,
      count: g._count.status,
    }));

    // Calculate ratio of active interviews to total applications
    const activeInterviewRate = totalApplications > 0 ? (activeInterviews / totalApplications) * 100 : 0;

    return {
      totalApplications,
      byStatus,
      recentApplications,
      recentActivity,
      monthlyActivity,
      resumeCount,
      activeInterviews,
      activeInterviewRate: parseFloat(activeInterviewRate.toFixed(1)),
    };
  }

  async getRecentActivityLogs(userId: string, limit: number = 10) {
    // A simplified activity log based on job applications for now,
    // in a real app this might aggregate from multiple tables (interviews, resume analysis, etc.)
    const recentJobs = await prisma.jobApplication.findMany({
      where: { userId },
      orderBy: { updatedAt: "desc" },
      take: limit,
      select: {
        id: true,
        companyName: true,
        role: true,
        status: true,
        updatedAt: true,
      },
    });

    return recentJobs.map(job => ({
      id: job.id,
      title: `Job Application: ${job.companyName}`,
      description: `Status updated to ${job.status} for ${job.role}`,
      timestamp: job.updatedAt,
      type: "JOB_UPDATE",
    }));
  }

  async getActionItems(userId: string) {
    const jobsNeedingFollowUp = await prisma.jobApplication.findMany({
      where: { 
        userId, 
        status: 'INTERVIEW', 
        updatedAt: { lte: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) } // No update in 3 days
      },
      select: { id: true, companyName: true, role: true },
      take: 5
    });

    const pendingAIAnalyses = await prisma.jobAnalysis.count({
      where: { userId, status: 'PROCESSING' }
    });

    return {
      jobsNeedingFollowUp,
      pendingAIAnalyses,
      suggestedAction: jobsNeedingFollowUp.length > 0 ? "Follow up on your recent interviews." : "Apply to some new jobs today!"
    };
  }

  async getDashboardSummary(userId: string) {
    const totalJobs = await prisma.jobApplication.count({ where: { userId } });
    const interviews = await prisma.jobApplication.count({ where: { userId, status: 'INTERVIEW' } });
    const offers = await prisma.jobApplication.count({ where: { userId, status: 'OFFER' } });
    
    let summaryText = "You're off to a great start. Keep applying!";
    if (offers > 0) {
      summaryText = `Congratulations! You have ${offers} offer(s) to review.`;
    } else if (interviews > 0) {
      summaryText = `You have ${interviews} interview(s) in progress. Prepare well!`;
    } else if (totalJobs > 10) {
      summaryText = "You've been applying consistently. The right opportunity is coming.";
    }

    return {
      totalJobs,
      interviews,
      offers,
      summaryText,
    };
  }

  async getDashboardAlerts(userId: string) {
    const now = new Date();
    
    // Find jobs in INTERVIEW status that were recently updated
    const upcomingInterviews = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: 'INTERVIEW',
        updatedAt: { gte: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000) }
      },
      select: { companyName: true, role: true },
      take: 2
    });

    const alerts = [];
    
    if (upcomingInterviews.length > 0) {
      upcomingInterviews.forEach(interview => {
        alerts.push({
          type: "URGENT",
          title: `Upcoming Interview: ${interview.companyName}`,
          message: `You have an active interview process for the ${interview.role} role. Make sure to prepare!`,
        });
      });
    }

    const pendingOffers = await prisma.jobApplication.count({
      where: { userId, status: 'OFFER' }
    });

    if (pendingOffers > 0) {
      alerts.push({
        type: "ACTION_REQUIRED",
        title: "Offers Awaiting Decision",
        message: `You have ${pendingOffers} offer(s) pending. Don't forget to respond to the recruiters.`,
      });
    }

    return alerts;
  }

  async getUpcomingEvents(userId: string) {
    const now = new Date();
    const nextWeek = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
    
    // In a real application, we'd query an Interview or Event table.
    // For now, we find jobs in INTERVIEW status that were recently updated
    // and mock upcoming event dates for them.
    const upcomingInterviews = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: 'INTERVIEW',
      },
      select: { id: true, companyName: true, role: true, updatedAt: true },
      orderBy: { updatedAt: "desc" },
      take: 3
    });

    const events = upcomingInterviews.map((interview, index) => {
      // Mock event dates based on the index to stagger them in the next few days
      const eventDate = new Date(now.getTime() + (index + 1) * 2 * 24 * 60 * 60 * 1000);
      
      return {
        id: `evt_${interview.id}`,
        jobId: interview.id,
        title: `Interview with ${interview.companyName}`,
        description: `${interview.role} - Technical Round`,
        date: eventDate,
        type: 'INTERVIEW'
      };
    });

    return {
      totalEvents: events.length,
      events
    };
  }

  async getDailyGoals(userId: string) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const applicationsToday = await prisma.jobApplication.count({
      where: {
        userId,
        appliedDate: { gte: today },
      },
    });

    const mockInterviewsCompletedToday = 0; // In reality, calculate from interview results

    const goals = [
      {
        id: "goal_1",
        title: "Apply to 3 jobs",
        current: applicationsToday,
        target: 3,
        isCompleted: applicationsToday >= 3,
        type: "APPLICATION"
      },
      {
        id: "goal_2",
        title: "Complete 1 mock interview",
        current: mockInterviewsCompletedToday,
        target: 1,
        isCompleted: mockInterviewsCompletedToday >= 1,
        type: "PRACTICE"
      }
    ];

    const progress = Math.min(100, Math.round(((applicationsToday / 3) * 50) + ((mockInterviewsCompletedToday / 1) * 50)));

    return {
      date: new Date().toISOString(),
      overallProgress: progress,
      goals
    };
  }

  async getRecommendedJobs(userId: string) {
    // Mock recommendations based on user's active applications
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { role: true },
      take: 5
    });

    const defaultRoles = ["Software Engineer", "Full Stack Developer", "Frontend Engineer"];
    const preferredRoles = applications.length > 0 
      ? applications.map(app => app.role) 
      : defaultRoles;

    const baseRole = preferredRoles[0] || "Software Engineer";

    const recommendations = [
      {
        id: "rec_1",
        title: `Senior ${baseRole}`,
        company: "TechNova Inc.",
        location: "Remote",
        matchScore: 92,
        salary: "$130k - $160k",
        postedAt: new Date(Date.now() - 1000 * 60 * 60 * 2) // 2 hours ago
      },
      {
        id: "rec_2",
        title: baseRole,
        company: "Global Systems Ltd",
        location: "New York, NY (Hybrid)",
        matchScore: 88,
        salary: "$110k - $140k",
        postedAt: new Date(Date.now() - 1000 * 60 * 60 * 24) // 1 day ago
      },
      {
        id: "rec_3",
        title: `Lead ${baseRole}`,
        company: "Innovate AI",
        location: "San Francisco, CA",
        matchScore: 85,
        salary: "$150k - $190k",
        postedAt: new Date(Date.now() - 1000 * 60 * 60 * 48) // 2 days ago
      }
    ];

    return recommendations;
  }

  async getWeeklySnapshot(userId: string) {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    const thisWeekApps = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: oneWeekAgo }
      }
    });

    const twoWeeksAgo = new Date();
    twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
    
    const lastWeekApps = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: twoWeeksAgo, lt: oneWeekAgo }
      }
    });

    const thisWeekCount = thisWeekApps.length;
    const lastWeekCount = lastWeekApps.length;
    const changePercentage = lastWeekCount > 0 
      ? Math.round(((thisWeekCount - lastWeekCount) / lastWeekCount) * 100) 
      : 100;

    return {
      timeframe: "Last 7 days",
      applicationsSubmitted: thisWeekCount,
      comparisonToLastWeek: `${changePercentage > 0 ? '+' : ''}${changePercentage}%`,
      interviewsScheduled: thisWeekApps.filter(app => app.status === "INTERVIEW").length,
      offersReceived: thisWeekApps.filter(app => app.status === "OFFER").length,
      topCompanyThisWeek: thisWeekApps.length > 0 ? thisWeekApps[0].companyName : "None yet"
    };
  }

  async getTopSkillsTrending(userId: string) {
    const recentJobs = await prisma.jobApplication.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: 15,
      select: { role: true, companyName: true }
    });

    if (recentJobs.length === 0) {
      return {
        message: "Apply to jobs to see trending skills in your target roles.",
        trending: []
      };
    }

    const primaryRoleUpper = recentJobs[0].role.toUpperCase();
    let mockSkills = [
      { skill: "Communication", trend: "+5%", priority: "High" },
      { skill: "Project Management", trend: "+2%", priority: "Medium" }
    ];

    if (primaryRoleUpper.includes("ENGINEER") || primaryRoleUpper.includes("DEVELOPER")) {
      mockSkills = [
        { skill: "TypeScript", trend: "+12%", priority: "High" },
        { skill: "React", trend: "+8%", priority: "High" },
        { skill: "GraphQL", trend: "+4%", priority: "Medium" },
        { skill: "Docker", trend: "+6%", priority: "High" }
      ];
    } else if (primaryRoleUpper.includes("DATA")) {
      mockSkills = [
        { skill: "Python", trend: "+15%", priority: "High" },
        { skill: "SQL", trend: "+10%", priority: "High" },
        { skill: "Airflow", trend: "+7%", priority: "Medium" }
      ];
    }

    return {
      basedOnRole: recentJobs[0].role,
      trending: mockSkills
    };
  }

  async getGamificationScore(userId: string) {
    // Calculate a simple engagement score based on their data
    const [totalApplications, resumeCount, activeInterviews] = await Promise.all([
      prisma.jobApplication.count({ where: { userId } }),
      prisma.resume.count({ where: { userId } }),
      prisma.jobApplication.count({ where: { userId, status: 'INTERVIEW' } }),
    ]);

    let score = 0;
    
    // Base score for having a resume
    if (resumeCount > 0) score += 20;
    if (resumeCount > 1) score += 10;
    
    // Score for applications
    score += Math.min(50, totalApplications * 2); // max 50 points
    
    // Score for interviews
    score += Math.min(20, activeInterviews * 5); // max 20 points
    
    let level = "Beginner";
    if (score >= 80) level = "Expert";
    else if (score >= 50) level = "Intermediate";
    
    let nextMilestone = "Add a resume to earn points!";
    if (resumeCount > 0 && totalApplications < 10) nextMilestone = "Apply to 10 jobs to reach the next level.";
    else if (totalApplications >= 10 && activeInterviews === 0) nextMilestone = "Secure an interview to boost your score.";
    else nextMilestone = "Keep up the great momentum!";

    return {
      score,
      maxScore: 100,
      level,
      totalApplications,
      resumeCount,
      activeInterviews,
      nextMilestone
    };
  }

  async getSkillGapAnalysis(userId: string) {
    // Find the most recently applied job to use as a baseline role
    const recentJob = await prisma.jobApplication.findFirst({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });

    if (!recentJob) {
      return {
        hasData: false,
        message: "Apply for a job first to get a personalized skill gap analysis.",
        gaps: []
      };
    }

    const roleName = recentJob.role.toLowerCase();
    
    // Mock the gap analysis logic
    let gaps = [];
    
    if (roleName.includes("frontend") || roleName.includes("react")) {
      gaps = [
        { skill: "Next.js", importance: "High", resources: ["Next.js Documentation", "Vercel Learn"] },
        { skill: "Tailwind CSS", importance: "Medium", resources: ["Tailwind Play", "CSS Tricks"] },
        { skill: "GraphQL", importance: "Medium", resources: ["Apollo Odyssey"] }
      ];
    } else if (roleName.includes("backend") || roleName.includes("node")) {
      gaps = [
        { skill: "Kubernetes", importance: "High", resources: ["K8s Docs", "Minikube Tutorial"] },
        { skill: "Redis", importance: "High", resources: ["Redis University"] },
        { skill: "gRPC", importance: "Low", resources: ["gRPC Quickstart"] }
      ];
    } else {
      gaps = [
        { skill: "Cloud Architecture (AWS/GCP)", importance: "High", resources: ["Cloud Guru", "AWS Training"] },
        { skill: "CI/CD Pipelines", importance: "Medium", resources: ["GitHub Actions Docs"] }
      ];
    }

    return {
      hasData: true,
      targetRole: recentJob.role,
      message: "Here are some skills frequently requested in your target role that you might be missing.",
      gaps
    };
  }

  async getBurnoutPredictor(userId: string) {
    // Determine burnout risk by analyzing application velocity over the past 4 weeks
    const fourWeeksAgo = new Date();
    fourWeeksAgo.setDate(fourWeeksAgo.getDate() - 28);
    
    const applications = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: fourWeeksAgo },
      },
      select: { createdAt: true },
      orderBy: { createdAt: "asc" }
    });

    if (applications.length < 5) {
      return {
        riskLevel: "Low",
        score: 10,
        message: "You have a light application load. No signs of burnout.",
        recommendation: "If you have the capacity, try setting a goal to apply to 2-3 jobs a week."
      };
    }

    // Check for clustering (doing too much in too few days) vs sustained pace
    const appsPerDay: Record<string, number> = {};
    for (const app of applications) {
      const dateKey = app.createdAt.toISOString().slice(0, 10);
      appsPerDay[dateKey] = (appsPerDay[dateKey] || 0) + 1;
    }

    const daysActive = Object.keys(appsPerDay).length;
    let maxAppsInOneDay = 0;
    Object.values(appsPerDay).forEach(count => {
      if (count > maxAppsInOneDay) maxAppsInOneDay = count;
    });

    let score = 0;
    
    // High volume + few days active = high risk (binge applying)
    if (applications.length > 40 && daysActive < 10) {
      score += 50;
    }
    
    // Huge spikes in single days
    if (maxAppsInOneDay > 15) {
      score += 30;
    }
    
    // Overall volume
    if (applications.length > 60) {
      score += 20;
    }

    let riskLevel = "Low";
    let message = "Your application pace looks sustainable.";
    let recommendation = "Keep up the consistent effort without overworking yourself.";

    if (score >= 70) {
      riskLevel = "High";
      message = "You are applying at a very intense pace with large spikes in activity.";
      recommendation = "Take a break! Set a hard limit of 3 high-quality applications per day.";
    } else if (score >= 40) {
      riskLevel = "Medium";
      message = "You're showing signs of \"binge applying.\"";
      recommendation = "Try to spread your applications out over the week rather than doing them all in one day.";
    }

    return {
      riskLevel,
      score,
      metrics: {
        totalLast4Weeks: applications.length,
        activeDaysLast4Weeks: daysActive,
        maxAppsInOneDay
      },
      message,
      recommendation
    };
  }

  async getMorningBriefing(userId: string) {
    const today = new Date().toISOString().slice(0, 10);
    
    // Urgent follow-ups (e.g., jobs in INTERVIEW state for more than a few days)
    const urgentFollowUps = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: 'INTERVIEW',
        updatedAt: { lte: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) }
      },
      select: { companyName: true, role: true },
      take: 3
    });

    const quotes = [
      "The expert in anything was once a beginner. — Helen Hayes",
      "Opportunities don't happen, you create them. — Chris Grosser",
      "It does not matter how slowly you go as long as you do not stop. — Confucius",
      "Success is not final, failure is not fatal: it is the courage to continue that counts. — Winston Churchill",
      "Believe you can and you're halfway there. — Theodore Roosevelt"
    ];

    const randomQuote = quotes[Math.floor(Math.random() * quotes.length)];

    return {
      date: today,
      greeting: "Good morning! Here's your daily briefing.",
      quoteOfTheDay: randomQuote,
      topPriority: urgentFollowUps.length > 0 
        ? `Follow up with ${urgentFollowUps[0].companyName} regarding the ${urgentFollowUps[0].role} role.`
        : "Apply to at least one new role that excites you.",
      urgentTasks: urgentFollowUps.map(f => `Pending interview response from ${f.companyName}`),
    };
  }

  async getConsistencyTracker(userId: string) {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const applications = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: thirtyDaysAgo }
      },
      select: { createdAt: true },
      orderBy: { createdAt: "desc" }
    });

    const activeDays = new Set(applications.map(app => app.createdAt.toISOString().slice(0, 10)));
    
    // Mock current streak
    let currentStreak = 0;
    const today = new Date().toISOString().slice(0, 10);
    const yesterdayDate = new Date();
    yesterdayDate.setDate(yesterdayDate.getDate() - 1);
    const yesterday = yesterdayDate.toISOString().slice(0, 10);

    if (activeDays.has(today) || activeDays.has(yesterday)) {
      currentStreak = Math.floor(Math.random() * 5) + 1; // mock
    }

    const consistencyScore = Math.round((activeDays.size / 30) * 100);

    let message = "Keep it up! Consistent applying yields the best results.";
    if (consistencyScore > 50) message = "You're extremely consistent! Great job.";
    else if (consistencyScore < 15) message = "Try to set aside 15 minutes a day to apply consistently.";

    return {
      activeDaysLast30: activeDays.size,
      consistencyScore,
      currentStreak,
      message
    };
  }

  async generateWeeklyReport(userId: string) {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    // Get jobs applied to this week
    const applicationsThisWeek = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: oneWeekAgo }
      }
    });

    // Get interviews scheduled this week
    const interviewsThisWeek = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: "INTERVIEW",
        updatedAt: { gte: oneWeekAgo }
      }
    });

    // Get rejections this week
    const rejectionsThisWeek = await prisma.jobApplication.count({
      where: {
        userId,
        status: "REJECTED",
        updatedAt: { gte: oneWeekAgo }
      }
    });

    // Mocking an AI encouraging message
    let encouragement = "";
    if (applicationsThisWeek.length > 5) {
      encouragement = "Incredible momentum! You're putting yourself out there and the numbers prove it.";
    } else if (interviewsThisWeek.length > 0) {
      encouragement = "You scored an interview this week! Time to start prepping.";
    } else {
      encouragement = "Every week is a new opportunity. Keep refining your resume and keep pushing!";
    }

    return {
      userId,
      reportPeriod: "Last 7 Days",
      metrics: {
        applicationsSent: applicationsThisWeek.length,
        interviewsSecured: interviewsThisWeek.length,
        rejections: rejectionsThisWeek,
        activeJobsInPipeline: await prisma.jobApplication.count({ where: { userId, status: { notIn: ["SAVED", "REJECTED", "WITHDRAWN"] } } })
      },
      topCompaniesApplied: applicationsThisWeek.map(app => app.companyName).slice(0, 3),
      encouragementMessage: encouragement,
      generatedAt: new Date().toISOString()
    };
  }

  async updateNotificationPreferences(userId: string, preferences: { emailWeeklyReport?: boolean, pushDailyGoals?: boolean }) {
    // In a real database, we would have a NotificationPreferences table or JSON column on User.
    // For this mock, we validate the input and return a success response simulating an update.
    
    if (typeof preferences.emailWeeklyReport !== "boolean" && typeof preferences.pushDailyGoals !== "boolean") {
      throw ApiError.badRequest("At least one valid preference flag must be provided.");
    }

    return {
      userId,
      preferencesUpdated: {
        emailWeeklyReport: preferences.emailWeeklyReport ?? true,
        pushDailyGoals: preferences.pushDailyGoals ?? true
      },
      updatedAt: new Date().toISOString(),
      message: "Notification preferences updated successfully."
    };
  }

  async snoozeNotifications(userId: string, snoozeDays: number) {
    if (!snoozeDays || snoozeDays < 1) {
      throw ApiError.badRequest("Must provide a valid number of days to snooze (minimum 1)");
    }
    
    // In a real application we would update a user settings record.
    // We will mock this logic and return the simulated update.
    
    const resumeDate = new Date();
    resumeDate.setDate(resumeDate.getDate() + snoozeDays);

    return {
      userId,
      snoozed: true,
      snoozeDays,
      resumeNotificationsAt: resumeDate.toISOString(),
      message: `All dashboard notifications are paused until ${resumeDate.toLocaleDateString()}`
    };
  }

  async dismissAlert(userId: string, alertId: string) {
    if (!alertId) {
      throw ApiError.badRequest("Alert ID is required to dismiss.");
    }
    
    // In a real application, we would update a user_alerts or dashboard_state table
    // For this mock implementation, we just return a success state to signify it was dismissed
    
    return {
      userId,
      alertId,
      dismissedAt: new Date().toISOString(),
      message: `Alert ${alertId} successfully dismissed.`
    };
  }

  async pinAlert(userId: string, alertId: string) {
    if (!alertId) {
      throw ApiError.badRequest("Alert ID is required to pin.");
    }
    
    // In a real database we would update an `isPinned` column in an Alerts table.
    // We mock this action since we don't have a dedicated Alerts table right now.
    
    return {
      userId,
      alertId,
      isPinned: true,
      pinnedAt: new Date().toISOString(),
      message: `Alert ${alertId} has been pinned to the top of your dashboard.`
    };
  }

  async dismissAllAlerts(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw ApiError.notFound("User not found");

    // In a real database we would update an Alert table.
    // Since alerts are dynamically generated here, we can mock dismissing them
    // by storing a "lastDismissedAll" timestamp on the user's profile/preferences.
    // For this mock, we just return a success result.
    
    return {
      userId,
      clearedAt: new Date().toISOString(),
      message: "All non-critical alerts have been dismissed."
    };
  }

  async clearAllActionItems(userId: string) {
    // In a real application we would have a table to track which action items were dismissed.
    // For now, since action items are derived from jobs needing follow-up, 
    // we can simulate clearing them by adding a timestamp to the user preferences.
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw ApiError.notFound("User not found");

    return {
      userId,
      clearedAt: new Date().toISOString(),
      message: "All pending action items have been marked as complete/cleared."
    };
  }

  async updateWidgetPreferences(userId: string, preferences: { showBurnout?: boolean, showGamification?: boolean, showConsistency?: boolean }) {
    if (typeof preferences.showBurnout !== "boolean" && typeof preferences.showGamification !== "boolean" && typeof preferences.showConsistency !== "boolean") {
      throw ApiError.badRequest("At least one valid widget preference flag must be provided.");
    }

    return {
      userId,
      widgetPreferences: {
        showBurnout: preferences.showBurnout ?? true,
        showGamification: preferences.showGamification ?? true,
        showConsistency: preferences.showConsistency ?? true
      },
      updatedAt: new Date().toISOString(),
      message: "Dashboard widget preferences updated successfully."
    };
  }

  async getGoalStreaks(userId: string) {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const applications = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: thirtyDaysAgo }
      },
      select: { createdAt: true },
      orderBy: { createdAt: "desc" }
    });

    const activeDays = new Set(applications.map(app => app.createdAt.toISOString().slice(0, 10)));
    
    const today = new Date().toISOString().slice(0, 10);
    const yesterdayDate = new Date();
    yesterdayDate.setDate(yesterdayDate.getDate() - 1);
    const yesterday = yesterdayDate.toISOString().slice(0, 10);

    let currentStreak = 0;
    
    if (activeDays.has(today) || activeDays.has(yesterday)) {
       currentStreak = Math.floor(Math.random() * 5) + 2; 
    }

    return {
      userId,
      currentStreakDays: currentStreak,
      longestStreakDays: Math.max(currentStreak, Math.floor(Math.random() * 10) + 3),
      totalGoalDaysMet: activeDays.size,
      message: currentStreak > 0 ? `You are on a ${currentStreak}-day streak!` : "Start applying today to build your streak!"
    };
  }

  async getCareerMilestones(userId: string) {
    const [totalApplications, totalInterviews, totalOffers] = await Promise.all([
      prisma.jobApplication.count({ where: { userId } }),
      prisma.jobApplication.count({ where: { userId, status: 'INTERVIEW' } }),
      prisma.jobApplication.count({ where: { userId, status: 'OFFER' } })
    ]);

    const milestones = [
      {
        id: "m_apps_10",
        title: "Getting Started",
        description: "Sent your first 10 applications",
        achieved: totalApplications >= 10,
        icon: "🚀"
      },
      {
        id: "m_apps_50",
        title: "Job Hunter",
        description: "Sent 50 applications",
        achieved: totalApplications >= 50,
        icon: "🎯"
      },
      {
        id: "m_int_1",
        title: "Foot in the Door",
        description: "Landed your first interview",
        achieved: totalInterviews >= 1,
        icon: "🤝"
      },
      {
        id: "m_int_5",
        title: "In Demand",
        description: "Landed 5 interviews",
        achieved: totalInterviews >= 5,
        icon: "🌟"
      },
      {
        id: "m_off_1",
        title: "The Big Win",
        description: "Received your first job offer",
        achieved: totalOffers >= 1,
        icon: "🎉"
      }
    ];

    const achievedCount = milestones.filter(m => m.achieved).length;

    return {
      userId,
      totalMilestones: milestones.length,
      achievedCount,
      progress: Math.round((achievedCount / milestones.length) * 100),
      milestones
    };
  }

  async getApplicationFlowFunnel(userId: string) {
    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { status: true }
    });

    const totalApplications = applications.length;
    
    if (totalApplications === 0) {
      return {
        hasData: false,
        message: "No applications found to construct a funnel.",
        funnel: []
      };
    }

    const applied = applications.filter(a => a.status !== "SAVED").length;
    const interviews = applications.filter(a => a.status === "INTERVIEW" || a.status === "OFFER").length;
    const offers = applications.filter(a => a.status === "OFFER").length;

    const funnel = [
      { stage: "Applied", count: applied, conversionRate: "100%" },
      { stage: "Interviewing", count: interviews, conversionRate: applied > 0 ? `${Math.round((interviews / applied) * 100)}%` : "0%" },
      { stage: "Offers", count: offers, conversionRate: interviews > 0 ? `${Math.round((offers / interviews) * 100)}%` : "0%" }
    ];

    return {
      hasData: true,
      totalApplications,
      funnel,
      message: "Application flow funnel generated successfully."
    };
  }

  async getUpcomingDeadlines(userId: string) {
    const now = new Date();
    
    // In a real app we'd have a specific Deadline table or date fields on JobApplication
    // For now we'll mock by finding recently updated jobs in APPLIED/INTERVIEW status
    const recentJobs = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: { in: ['APPLIED', 'INTERVIEW'] },
      },
      select: { id: true, companyName: true, role: true, status: true },
      take: 5
    });

    const deadlines = recentJobs.map((job, index) => {
      const deadlineDate = new Date(now.getTime() + (index + 1) * 24 * 60 * 60 * 1000);
      let task = "Submit take-home assignment";
      if (job.status === "APPLIED") task = "Follow up on application";
      
      return {
        jobId: job.id,
        company: job.companyName,
        role: job.role,
        task,
        deadlineDate,
        urgency: index === 0 ? "High" : "Medium"
      };
    });

    return {
      totalDeadlines: deadlines.length,
      deadlines,
      message: deadlines.length > 0 
        ? "You have some upcoming deadlines to keep track of." 
        : "No immediate deadlines! Great job staying on top of things."
    };
  }

  async getApplicationSuggestions(userId: string) {
    // Generate mock application suggestions based on previous rejections or saved jobs
    const recentJobs = await prisma.jobApplication.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: 5
    });
    
    let baseRole = "Software Engineer";
    if (recentJobs.length > 0) {
      baseRole = recentJobs[0].role;
    }

    const suggestions = [
      {
        id: "sug_1",
        title: `Senior ${baseRole}`,
        company: "InnovateTech",
        matchReason: "Your experience closely matches their tech stack requirements.",
        actionRequired: "Tailor your resume for leadership before applying.",
        salaryPotential: "High"
      },
      {
        id: "sug_2",
        title: baseRole,
        company: "Global Solutions",
        matchReason: "They recently opened 5 new positions in this role.",
        actionRequired: "Apply quickly to be among the first applicants.",
        salaryPotential: "Medium"
      }
    ];

    return {
      userId,
      generatedAt: new Date().toISOString(),
      suggestionsCount: suggestions.length,
      suggestions,
      message: "Here are some targeted application suggestions for you."
    };
  }

  async getWeeklyPerformance(userId: string) {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    const applications = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: oneWeekAgo }
      }
    });

    const applicationsSubmitted = applications.length;
    const interviewsSecured = applications.filter(app => app.status === "INTERVIEW").length;
    const offersReceived = applications.filter(app => app.status === "OFFER").length;

    const performanceScore = Math.min(100, (applicationsSubmitted * 2) + (interviewsSecured * 10) + (offersReceived * 20));

    let feedback = "Good effort this week!";
    if (performanceScore > 80) feedback = "Outstanding performance! You are highly active.";
    else if (performanceScore < 20) feedback = "Consider increasing your application volume next week.";

    return {
      timeframe: "Last 7 Days",
      metrics: {
        applicationsSubmitted,
        interviewsSecured,
        offersReceived,
      },
      performanceScore,
      feedback,
      message: "Weekly performance fetched successfully."
    };
  }

  async getInterviewPrepGuide(userId: string) {
    const upcomingInterviews = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: 'INTERVIEW'
      },
      select: { companyName: true, role: true },
      take: 1
    });

    if (upcomingInterviews.length === 0) {
      return {
        hasUpcomingInterviews: false,
        message: "You don't have any upcoming interviews right now. Keep applying!",
        guide: null
      };
    }

    const { companyName, role } = upcomingInterviews[0];

    // Generate a mock prep guide tailored to the role
    const guide = {
      company: companyName,
      role: role,
      recommendedTopics: ["System Design", "Behavioral (STAR Method)", "Data Structures"],
      commonQuestions: [
        `Why do you want to work at ${companyName}?`,
        `Describe a time you had a conflict with a teammate while working as a ${role}.`,
        "How do you handle tight deadlines?"
      ],
      checklist: [
        "Research the company's recent news",
        "Prepare 3 questions to ask the interviewer",
        "Test your audio and video setup"
      ]
    };

    return {
      hasUpcomingInterviews: true,
      guide,
      message: `Prep guide generated for your upcoming interview at ${companyName}.`
    };
  }
}
