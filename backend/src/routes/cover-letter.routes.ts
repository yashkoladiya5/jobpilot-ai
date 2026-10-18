import { Router } from "express";
import {
  generateCoverLetter,
  getCoverLetter,
  getCoverLetters,
  updateCoverLetter,
  deleteCoverLetter,
  adjustTone,
  scoreLetterSpecificity,
  checkCallToAction,
  checkLengthConstraints,
  scoreOpeningHook,
} from "../controllers/cover-letter.controller";
import { authenticate } from "../middleware/auth";

/**
 * Express router for cover letter endpoints.
 * Handles generation and retrieval of AI-crafted cover letters.
 */
const router = Router();

router.use(authenticate);

router.post("/generate", generateCoverLetter);
router.get("/list", getCoverLetters);
router.get("/:id", getCoverLetter);
router.patch("/:id", updateCoverLetter);
router.delete("/:id", deleteCoverLetter);
router.post("/:id/adjust-tone", adjustTone);
router.get("/:id/specificity", scoreLetterSpecificity);
router.get("/:id/call-to-action", checkCallToAction);
router.get("/:id/length-constraints", checkLengthConstraints);
router.get("/:id/opening-hook", scoreOpeningHook);

export default router;
