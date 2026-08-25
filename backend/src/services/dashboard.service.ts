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
}
