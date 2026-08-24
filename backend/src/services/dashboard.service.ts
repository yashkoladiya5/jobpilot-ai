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
}
