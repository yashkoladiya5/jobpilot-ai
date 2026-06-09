import { Router } from "express";
import { register, login, getMe } from "../controllers/auth.controller";
import { authenticate } from "../middleware/auth";
import { validate } from "../middleware/validate";
import { registerSchema, loginSchema } from "../validators/auth.validator";
import { authLimiter } from "../middleware/rateLimiter";

const router = Router();

router.post("/register", validate(registerSchema), register);
router.post("/login", authLimiter, validate(loginSchema), login);
router.get("/me", authenticate, getMe);

export default router;
