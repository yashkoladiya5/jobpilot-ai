import prisma from "../config/prisma";

export class DashboardService {
  async getStats(userId: string) {
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const [totalApplications, grouped, recentApplications, recentActivity, resumeCount] =
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

        prisma.resume.count({ where: { userId } }),
      ]);

    const byStatus = grouped.map((g) => ({
      status: g.status,
      count: g._count.status,
    }));

    return {
      totalApplications,
      byStatus,
      recentApplications,
      recentActivity,
      resumeCount,
    };
  }
}
