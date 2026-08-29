import { Router } from "express";
import {
  getJobs,
  createJob,
  getJobById,
  updateJob,
  deleteJob,
  getJobsAnalytics,
  updateJobStatus,
  bulkUpdateStatus,
  bulkDeleteJobs,
  updateJobNote,
  archiveJob,
  getJobsNeedingFollowUp,
  getJobNotesSummary,
  getJobActionItems,
  getJobApplicationVelocity,
  getDeadlineReminders,
  getSalaryNegotiationPrep,
  getInterviewPrepChecklist,
  estimateCommuteTime,
  runAutoArchiving,
  scheduleInterview,
  submitInterviewFeedback,
  addJobContact,
  duplicateJob,
} from "../controllers/job.controller";
import { authenticate } from "../middleware/auth";
import { validate } from "../middleware/validate";
import { createJobSchema, updateJobSchema } from "../validators/job.validator";

/**
 * Express router for managing job application tracking.
 * Provides CRUD operations for user job records securely.
 */
const router = Router();

// Custom endpoints
router.get("/analytics/summary", authenticate, getJobsAnalytics);
router.get("/analytics/velocity", authenticate, getJobApplicationVelocity);
router.get("/reminders/deadlines", authenticate, getDeadlineReminders);
router.get("/needs-follow-up", authenticate, getJobsNeedingFollowUp);
router.get("/notes/summary", authenticate, getJobNotesSummary);
router.get("/action-items", authenticate, getJobActionItems);
router.patch("/bulk/status", authenticate, bulkUpdateStatus);
router.post("/bulk/delete", authenticate, bulkDeleteJobs);
router.patch("/:id/status", authenticate, updateJobStatus);
router.patch("/:id/note", authenticate, updateJobNote);
router.patch("/:id/archive", authenticate, archiveJob);
router.get("/:id/negotiation-prep", authenticate, getSalaryNegotiationPrep);
router.get("/:id/interview-checklist", authenticate, getInterviewPrepChecklist);
router.get("/:id/commute-estimate", authenticate, estimateCommuteTime);
router.post("/auto-archive", authenticate, runAutoArchiving);
router.post("/:id/schedule-interview", authenticate, scheduleInterview);
router.post("/:id/interview-feedback", authenticate, submitInterviewFeedback);
router.post("/:id/contact", authenticate, addJobContact);
router.post("/:id/duplicate", authenticate, duplicateJob);

// CRUD operations for jobs, all requiring user authentication
router.get("/", authenticate, getJobs);
router.post("/", authenticate, validate(createJobSchema), createJob);
router.get("/:id", authenticate, getJobById);
router.put("/:id", authenticate, validate(updateJobSchema), updateJob);
router.delete("/:id", authenticate, deleteJob);

export default router;
