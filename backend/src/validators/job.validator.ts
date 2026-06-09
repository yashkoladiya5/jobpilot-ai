import { z } from "zod";

const jobStatusEnum = z.enum([
  "saved",
  "applied",
  "interviewing",
  "offered",
  "rejected",
  "accepted",
  "withdrawn",
]);

export const createJobSchema = z.object({
  body: z.object({
    companyName: z.string(),
    role: z.string(),
    jobUrl: z.string().url().optional(),
    salaryRange: z.string().optional(),
    location: z.string().optional(),
    status: jobStatusEnum,
    notes: z.string().optional(),
  }),
});

export const updateJobSchema = z.object({
  body: z.object({
    companyName: z.string().optional(),
    role: z.string().optional(),
    jobUrl: z.string().url().optional(),
    salaryRange: z.string().optional(),
    location: z.string().optional(),
    status: jobStatusEnum.optional(),
    notes: z.string().optional(),
  }),
});
