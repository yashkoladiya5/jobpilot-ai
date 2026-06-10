import { Router } from "express";
import authRoutes from "./auth.routes";
import jobRoutes from "./job.routes";
import resumeRoutes from "./resume.routes";
import dashboardRoutes from "./dashboard.routes";
import aiRoutes from "./ai.routes";

const router = Router();

router.use("/auth", authRoutes);
router.use("/jobs", jobRoutes);
router.use("/resumes", resumeRoutes);
router.use("/dashboard", dashboardRoutes);
router.use("/ai", aiRoutes);

export { router as routes };
