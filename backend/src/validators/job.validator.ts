import { z } from "zod";

const jobStatusEnum = z.enum([
  "SAVED",
  "APPLIED",
  "INTERVIEW",
  "OFFER",
  "REJECTED",
  "WITHDRAWN",
]);

export const createJobSchema = z.object({
  body: z.object({
    companyName: z.string().min(1, "Company name is required"),
    role: z.string().min(1, "Role is required"),
    jobUrl: z.string().url().optional().or(z.literal("")),
    salaryRange: z.string().optional(),
    location: z.string().optional(),
    status: jobStatusEnum.optional(),
    notes: z.string().optional(),
    resumeId: z.string().optional(),
  }),
});

export const updateJobSchema = z.object({
  body: z.object({
    companyName: z.string().min(1).optional(),
    role: z.string().min(1).optional(),
    jobUrl: z.string().url().optional().or(z.literal("")),
    salaryRange: z.string().optional(),
    location: z.string().optional(),
    status: jobStatusEnum.optional(),
    notes: z.string().optional(),
    resumeId: z.string().optional(),
  }),
});
