import { Router } from "express";
import { register, login, getMe, deleteAccount } from "../controllers/auth.controller";
import { authenticate } from "../middleware/auth";
import { validate } from "../middleware/validate";
import { registerSchema, loginSchema } from "../validators/auth.validator";
import { authLimiter } from "../middleware/rateLimiter";

// Router instance specifically for authentication endpoints
const router = Router();

router.post("/register", validate(registerSchema), register);
router.post("/login", authLimiter, validate(loginSchema), login);
router.get("/me", authenticate, getMe);
router.delete("/me", authenticate, deleteAccount);

export default router;
