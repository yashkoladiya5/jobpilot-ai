import prisma from "../config/prisma";
import { ApiError } from "../utils/ApiError";

/**
 * Service handling all business logic and database interactions for Job Applications.
 */
export class JobService {
  async getJobs(
    userId: string,
    query?: {
      search?: string;
      status?: string;
      sortBy?: string;
      sortOrder?: string;
    }
  ) {
    // Initialize base query filtering by the authenticated user
    const where: any = { userId };
    if (query?.status) {
      where.status = query.status;
    }
    if (query?.search) {
      where.OR = [
        { companyName: { contains: query.search, mode: "insensitive" } },
        { role: { contains: query.search, mode: "insensitive" } },
      ];
    }
    let orderBy: any = { appliedDate: "desc" };
    if (query?.sortBy) {
      const validSortFields = ["appliedDate", "companyName", "status", "createdAt"];
      if (validSortFields.includes(query.sortBy)) {
        orderBy = { [query.sortBy]: query.sortOrder === "asc" ? "asc" : "desc" };
      }
    }
    return prisma.jobApplication.findMany({ where, orderBy });
  }

  async getJobById(userId: string, id: string) {
    const job = await prisma.jobApplication.findFirst({
      where: { id, userId },
    });

    if (!job) {
      throw ApiError.notFound("Job application not found");
    }

    return job;
  }

  async createJob(
    userId: string,
    data: {
      companyName: string;
      role: string;
      jobUrl?: string;
      salaryRange?: string;
      location?: string;
      status?: string;
      notes?: string;
      resumeId?: string;
    }
  ) {
    return prisma.jobApplication.create({
      data: {
        userId,
        companyName: data.companyName,
        role: data.role,
        jobUrl: data.jobUrl,
        salaryRange: data.salaryRange,
        location: data.location,
        status: (data.status ?? "SAVED") as "SAVED" | "APPLIED" | "INTERVIEW" | "OFFER" | "REJECTED" | "WITHDRAWN",
        notes: data.notes,
        resumeId: data.resumeId,
      },
    });
  }

  async updateJob(
    userId: string,
    id: string,
    data: Partial<{
      companyName: string;
      role: string;
      jobUrl: string;
      salaryRange: string;
      location: string;
      status: string;
      notes: string;
      resumeId: string;
    }>
  ) {
    await this.getJobById(userId, id);

    return prisma.jobApplication.update({
      where: { id },
      data: {
        companyName: data.companyName,
        role: data.role,
        jobUrl: data.jobUrl,
        salaryRange: data.salaryRange,
        location: data.location,
        notes: data.notes,
        ...(data.status ? { status: data.status as "SAVED" | "APPLIED" | "INTERVIEW" | "OFFER" | "REJECTED" | "WITHDRAWN" } : {}),
        ...(data.resumeId !== undefined ? { resumeId: data.resumeId } : {}),
      },
    });
  }

  async deleteJob(userId: string, id: string): Promise<void> {
    await this.getJobById(userId, id);

    await prisma.jobApplication.delete({
      where: { id },
    });
  }

  async updateJobStatus(userId: string, id: string, status: string) {
    const validStatuses = ["SAVED", "APPLIED", "INTERVIEW", "OFFER", "REJECTED", "WITHDRAWN"];
    if (!validStatuses.includes(status)) {
      throw ApiError.badRequest("Invalid job status provided");
    }

    await this.getJobById(userId, id);

    return prisma.jobApplication.update({
      where: { id },
      data: { status: status as any },
    });
  }

  async updateJobNote(userId: string, id: string, notes: string) {
    // We get the job to ensure it belongs to the user and exists
    await this.getJobById(userId, id);

    return prisma.jobApplication.update({
      where: { id },
      data: { notes },
    });
  }

  async archiveJob(userId: string, id: string) {
    const job = await this.getJobById(userId, id);
    
    // We mock archiving by prefixing the note and setting a terminal status
    const archivedNote = `[ARCHIVED on ${new Date().toISOString()}]\n${job.notes || ''}`;

    return prisma.jobApplication.update({
      where: { id },
      data: { 
        status: "WITHDRAWN", // Using a valid status from the schema as archive state
        notes: archivedNote 
      },
    });
  }

  async getJobsAnalytics(userId: string) {
    const jobs = await prisma.jobApplication.findMany({
      where: { userId },
      select: { status: true },
    });

    const analytics = {
      total: jobs.length,
      saved: jobs.filter(j => j.status === 'SAVED').length,
      applied: jobs.filter(j => j.status === 'APPLIED').length,
      interviewing: jobs.filter(j => j.status === 'INTERVIEW').length,
      offers: jobs.filter(j => j.status === 'OFFER').length,
      rejected: jobs.filter(j => j.status === 'REJECTED').length,
      withdrawn: jobs.filter(j => j.status === 'WITHDRAWN').length,
    };

    return analytics;
  }

  async bulkUpdateJobStatus(userId: string, jobIds: string[], status: string) {
    const validStatuses = ["SAVED", "APPLIED", "INTERVIEW", "OFFER", "REJECTED", "WITHDRAWN"];
    if (!validStatuses.includes(status)) {
      throw ApiError.badRequest("Invalid job status provided");
    }

    if (!jobIds || jobIds.length === 0) {
      throw ApiError.badRequest("No job IDs provided for bulk update");
    }

    const updated = await prisma.jobApplication.updateMany({
      where: { 
        id: { in: jobIds },
        userId 
      },
      data: { status: status as any },
    });

    return { count: updated.count };
  }

  async bulkDeleteJobs(userId: string, jobIds: string[]) {
    if (!jobIds || jobIds.length === 0) {
      throw ApiError.badRequest("No job IDs provided for bulk deletion");
    }

    const deleted = await prisma.jobApplication.deleteMany({
      where: { 
        id: { in: jobIds },
        userId 
      },
    });

    return { count: deleted.count };
  }

  async getJobsNeedingFollowUp(userId: string) {
    const fourteenDaysAgo = new Date();
    fourteenDaysAgo.setDate(fourteenDaysAgo.getDate() - 14);

    const jobs = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: { in: ["APPLIED", "INTERVIEW"] },
        updatedAt: { lte: fourteenDaysAgo }
      },
      orderBy: { updatedAt: "asc" },
      take: 10
    });

    return jobs.map(job => ({
      id: job.id,
      companyName: job.companyName,
      role: job.role,
      status: job.status,
      daysSinceLastUpdate: Math.floor((new Date().getTime() - job.updatedAt.getTime()) / (1000 * 60 * 60 * 24)),
      suggestedAction: job.status === "APPLIED" 
        ? "Send a polite follow-up email to the recruiter."
        : "Check in on your interview feedback."
    }));
  }

  async getJobNotesSummary(userId: string) {
    const jobsWithNotes = await prisma.jobApplication.findMany({
      where: {
        userId,
        notes: { not: null, not: "" }
      },
      select: {
        id: true,
        companyName: true,
        role: true,
        notes: true,
        updatedAt: true
      },
      orderBy: { updatedAt: "desc" },
      take: 20
    });

    const totalNotesLength = jobsWithNotes.reduce((acc, job) => acc + (job.notes?.length || 0), 0);

    return {
      totalJobsWithNotes: jobsWithNotes.length,
      averageNoteLength: jobsWithNotes.length > 0 ? Math.round(totalNotesLength / jobsWithNotes.length) : 0,
      recentNotes: jobsWithNotes.slice(0, 5)
    };
  }

  async getJobActionItems(userId: string) {
    const jobs = await prisma.jobApplication.findMany({
      where: { userId, status: { notIn: ["REJECTED", "WITHDRAWN", "SAVED"] } },
      orderBy: { updatedAt: "desc" },
    });

    const actionItems = [];
    const now = new Date().getTime();

    for (const job of jobs) {
      const daysSinceUpdate = Math.floor((now - job.updatedAt.getTime()) / (1000 * 60 * 60 * 24));
      
      if (job.status === "APPLIED" && daysSinceUpdate >= 7) {
        actionItems.push({
          jobId: job.id,
          company: job.companyName,
          role: job.role,
          type: "FOLLOW_UP",
          priority: daysSinceUpdate >= 14 ? "HIGH" : "MEDIUM",
          message: `It's been ${daysSinceUpdate} days since you applied. Consider sending a follow-up email.`
        });
      } else if (job.status === "INTERVIEW") {
        actionItems.push({
          jobId: job.id,
          company: job.companyName,
          role: job.role,
          type: "PREPARE",
          priority: "HIGH",
          message: "You have an active interview phase. Have you practiced your mock interviews recently?"
        });
      } else if (job.status === "OFFER" && daysSinceUpdate >= 3) {
        actionItems.push({
          jobId: job.id,
          company: job.companyName,
          role: job.role,
          type: "DECISION",
          priority: "HIGH",
          message: "You received an offer recently. Don't forget to negotiate or respond by the deadline."
        });
      }
    }

    return actionItems.slice(0, 5); // Return top 5 most relevant action items
  }

  async getJobApplicationVelocity(userId: string) {
    const fourWeeksAgo = new Date();
    fourWeeksAgo.setDate(fourWeeksAgo.getDate() - 28);
    
    const applications = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: fourWeeksAgo },
      },
      select: { createdAt: true },
    });

    const weeklyVelocity = [0, 0, 0, 0]; // Week 1 (oldest), Week 2, Week 3, Week 4 (current)
    const now = new Date().getTime();

    for (const app of applications) {
      const daysAgo = Math.floor((now - app.createdAt.getTime()) / (1000 * 60 * 60 * 24));
      
      if (daysAgo < 7) weeklyVelocity[3]++;
      else if (daysAgo < 14) weeklyVelocity[2]++;
      else if (daysAgo < 21) weeklyVelocity[1]++;
      else if (daysAgo < 28) weeklyVelocity[0]++;
    }

    const currentPace = weeklyVelocity[3];
    const previousPace = weeklyVelocity[2];
    
    let trend = "stable";
    if (currentPace > previousPace) trend = "increasing";
    else if (currentPace < previousPace) trend = "decreasing";

    return {
      totalLast4Weeks: applications.length,
      weeklyVelocity,
      currentPace,
      trend,
      message: trend === "decreasing" ? "Your application velocity has dropped recently. Try to submit a few more this week!" : "Great job maintaining your application momentum!"
    };
  }
}
