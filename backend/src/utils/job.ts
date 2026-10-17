import prisma from "../config/prisma";
import { Prisma, JobApplication } from "@prisma/client";
import { ApiError } from "./ApiError";

/**
 * Loads a job application owned by the given user, throwing a 404 when it does
 * not exist or belongs to another user. An `include` may be provided to attach
 * related records (e.g. `resume`) to the returned row.
 */
export async function requireOwnedJob(
  userId: string,
  jobId: string,
  include: undefined,
  message: string,
): Promise<JobApplication>;
export async function requireOwnedJob<T extends Prisma.JobApplicationInclude>(
  userId: string,
  jobId: string,
  include: T,
  message?: string,
): Promise<Prisma.JobApplicationGetPayload<{ include: T }>>;
export async function requireOwnedJob<T extends Prisma.JobApplicationInclude>(
  userId: string,
  jobId: string,
  include?: T,
  message = "Job application not found",
) {
  const job = await prisma.jobApplication.findFirst({
    where: { id: jobId, userId },
    include,
  });
  if (!job) {
    throw ApiError.notFound(message);
  }
  return job;
}