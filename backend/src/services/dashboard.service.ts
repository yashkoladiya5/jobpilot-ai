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
}
