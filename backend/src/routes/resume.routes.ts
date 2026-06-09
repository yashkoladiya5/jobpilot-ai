import { Router } from "express";
import {
  uploadResume,
  getResumes,
  getResume,
  deleteResume,
} from "../controllers/resume.controller";
import { authenticate } from "../middleware/auth";
import { upload } from "../middleware/upload";

const router = Router();

router.post("/upload", authenticate, upload.single("resume"), uploadResume);
router.get("/", authenticate, getResumes);
router.get("/:id", authenticate, getResume);
router.delete("/:id", authenticate, deleteResume);

export default router;
