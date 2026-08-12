import { Router } from "express";
import {
  getJobs,
  createJob,
  getJobById,
  updateJob,
  deleteJob,
} from "../controllers/job.controller";
import { authenticate } from "../middleware/auth";
import { validate } from "../middleware/validate";
import { createJobSchema, updateJobSchema } from "../validators/job.validator";

/**
 * Express router for managing job application tracking.
 * Provides CRUD operations for user job records securely.
 */
const router = Router();

// CRUD operations for jobs, all requiring user authentication
router.get("/", authenticate, getJobs);
router.post("/", authenticate, validate(createJobSchema), createJob);
router.get("/:id", authenticate, getJobById);
router.put("/:id", authenticate, validate(updateJobSchema), updateJob);
router.delete("/:id", authenticate, deleteJob);

export default router;
