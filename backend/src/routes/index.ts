import { Router } from "express";
import authRoutes from "./auth.routes";
import jobRoutes from "./job.routes";
import resumeRoutes from "./resume.routes";
import dashboardRoutes from "./dashboard.routes";

const router = Router();

router.use("/auth", authRoutes);
router.use("/jobs", jobRoutes);
router.use("/resumes", resumeRoutes);
router.use("/dashboard", dashboardRoutes);

export { router as routes };
