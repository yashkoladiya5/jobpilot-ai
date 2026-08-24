import { Router } from "express";
import {
  uploadResume,
  getResumes,
  getResume,
  deleteResume,
  setPrimaryResume,
  renameResume,
  getPrimaryResume,
  duplicateResume,
} from "../controllers/resume.controller";
import { authenticate } from "../middleware/auth";
import { upload } from "../middleware/upload";

/**
 * Express router for resume file management.
 * Supports secure uploading, deletion, and primary selection operations.
 */
const router = Router();

// Define rate limiting config placeholder for file uploads to prevent abuse
// e.g. const uploadLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 10 });
// router.post("/upload", authenticate, uploadLimiter, upload.single("resume"), uploadResume);

router.post("/upload", authenticate, upload.single("resume"), uploadResume);

// -----------------------------------------------------------------------
// Fetching operations
// -----------------------------------------------------------------------
router.get("/", authenticate, getResumes);
router.get("/primary", authenticate, getPrimaryResume);
router.get("/:id", authenticate, getResume);

// -----------------------------------------------------------------------
// Mutation operations
// -----------------------------------------------------------------------
router.delete("/:id", authenticate, deleteResume);
router.patch("/:id/primary", authenticate, setPrimaryResume);
router.patch("/:id/rename", authenticate, renameResume);
router.post("/:id/duplicate", authenticate, duplicateResume);

export default router;
