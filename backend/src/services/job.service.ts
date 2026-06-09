import prisma from "../config/prisma";
import { ApiError } from "../utils/ApiError";

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
}
