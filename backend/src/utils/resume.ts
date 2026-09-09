import prisma from "../config/prisma";
import { Prisma, Resume } from "@prisma/client";
import { ApiError } from "./ApiError";

/**
 * Loads a resume owned by the given user, throwing a 404 when it does not exist
 * or belongs to another user. An `include` may be provided to attach related
 * records (e.g. `resumeAnalyses`) to the returned row.
 */
export async function requireOwnedResume(userId: string, resumeId: string): Promise<Resume>;
export async function requireOwnedResume<T extends Prisma.ResumeInclude>(
  userId: string,
  resumeId: string,
  include: T,
): Promise<Prisma.ResumeGetPayload<{ include: T }>>;
export async function requireOwnedResume<T extends Prisma.ResumeInclude>(
  userId: string,
  resumeId: string,
  include?: T,
) {
  const resume = await prisma.resume.findFirst({
    where: { id: resumeId, userId },
    include,
  });
  if (!resume) {
    throw ApiError.notFound("Resume not found");
  }
  return resume;
}