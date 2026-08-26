import { Router } from "express";
import { register, login, getMe, deleteAccount, updatePassword, updateEmail, updateName, getActiveSessions, getLoginHistory, registerDevice, initiateMfaSetup, verifyMfaSetup, generateBackupCodes, initiatePasswordlessLogin, initiateSmsTwoFactor, getLoginStreak, revokeSession } from "../controllers/auth.controller";
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
router.patch("/password", authenticate, updatePassword);
router.patch("/email", authenticate, updateEmail);
router.patch("/name", authenticate, updateName);
router.get("/sessions", authenticate, getActiveSessions);
router.get("/login-history", authenticate, getLoginHistory);
router.post("/device", authenticate, registerDevice);
router.post("/mfa/initiate", authenticate, initiateMfaSetup);
router.post("/mfa/sms/initiate", authenticate, initiateSmsTwoFactor);
router.post("/mfa/verify", authenticate, verifyMfaSetup);
router.post("/mfa/backup-codes", authenticate, generateBackupCodes);
router.post("/passwordless/initiate", initiatePasswordlessLogin);
router.get("/streak", authenticate, getLoginStreak);
router.delete("/sessions/:sessionId", authenticate, revokeSession);

export default router;
