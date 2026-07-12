import { Router } from "express";
import {
  generateCoverLetter,
  getCoverLetter,
  getCoverLetters,
} from "../controllers/cover-letter.controller";
import { authenticate } from "../middleware/auth";

const router = Router();

router.use(authenticate);

router.post("/generate", generateCoverLetter);
router.get("/list", getCoverLetters);
router.get("/:id", getCoverLetter);

export default router;
