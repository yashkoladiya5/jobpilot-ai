import { Router } from "express";
import { authenticate } from "../middleware/auth";
import { getStats } from "../controllers/dashboard.controller";

/**
 * Express router for dashboard endpoints.
 * Fetches user statistics and recent activity for the home view.
 */
const router = Router();

router.get("/stats", authenticate, getStats);

export default router;
