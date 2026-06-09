import prisma from "../config/prisma";
import { ApiError } from "../utils/ApiError";

export class JobService {
  async getJobs(userId: string) {
    return prisma.jobApplication.findMany({
      where: { userId },
      orderBy: { appliedDate: "desc" },
    });
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
        status: (data.status as any) ?? "SAVED",
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
        ...data,
        status: data.status as any,
      },
    });
  }

  async deleteJob(userId: string, id: string): Promise<void> {
    await this.getJobById(userId, id);

    await prisma.jobApplication.delete({
      where: { id },
    });
  }
}
