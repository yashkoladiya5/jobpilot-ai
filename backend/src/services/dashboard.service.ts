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
}
