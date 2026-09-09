import { ApplicationStatus } from "@prisma/client";

/**
 * Statuses considered active/in-progress when deriving pipeline activity.
 */
export const ACTIVE_APPLICATION_STATUSES: ApplicationStatus[] = ["APPLIED", "INTERVIEW"];