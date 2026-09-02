import { Router } from "express";
import { register, login, getMe, deleteAccount, updatePassword, updateEmail, updateName, getActiveSessions, getLoginHistory, registerDevice, initiateMfaSetup, verifyMfaSetup, generateBackupCodes, initiatePasswordlessLogin, initiateSmsTwoFactor, getLoginStreak, revokeSession, exportUserData, getUserSecurityScore, trustDevice, getProfileCompleteness, verifyEmailDomain, toggleTwoFactorAuth, verifySessionHealth, revokeOtherSessions, terminateIdleSessions, revokeAllSessions, getAccountSecurityAudit, getEmailAliases, addEmailAlias, removeEmailAlias, getTrustedDevices, getSessionMapCoordinates, registerDeviceLocation, renameTrustedDevice } from "../controllers/auth.controller";
import { authenticate } from "../middleware/auth";
import { validate } from "../middleware/validate";
import { registerSchema, loginSchema } from "../validators/auth.validator";
import { authLimiter } from "../middleware/rateLimiter";

// Router instance specifically for authentication endpoints
const router = Router();

router.post("/verify-domain", verifyEmailDomain);
router.post("/register", authLimiter, validate(registerSchema), register);
router.post("/login", authLimiter, validate(loginSchema), login);
router.get("/me", authenticate, getMe);
router.delete("/me", authenticate, deleteAccount);
router.patch("/password", authenticate, updatePassword);
router.patch("/email", authenticate, updateEmail);
router.patch("/name", authenticate, updateName);
router.get("/sessions", authenticate, getActiveSessions);
router.get("/login-history", authenticate, getLoginHistory);
router.post("/device", authenticate, registerDevice);
router.get("/device/trust", authenticate, getTrustedDevices);
router.post("/device/trust", authenticate, trustDevice);
router.post("/mfa/initiate", authenticate, initiateMfaSetup);
router.post("/mfa/sms/initiate", authenticate, initiateSmsTwoFactor);
router.post("/mfa/verify", authenticate, verifyMfaSetup);
router.patch("/mfa/toggle", authenticate, toggleTwoFactorAuth);
router.post("/mfa/backup-codes", authenticate, generateBackupCodes);
router.post("/passwordless/initiate", initiatePasswordlessLogin);
router.get("/streak", authenticate, getLoginStreak);
router.delete("/sessions/other", authenticate, revokeOtherSessions);
router.get("/sessions/map", authenticate, getSessionMapCoordinates);
router.delete("/sessions/idle", authenticate, terminateIdleSessions);
router.delete("/sessions", authenticate, revokeAllSessions);
router.delete("/sessions/:sessionId", authenticate, revokeSession);
router.get("/export", authenticate, exportUserData);
router.get("/security-score", authenticate, getUserSecurityScore);
router.get("/session/health", authenticate, verifySessionHealth);
router.get("/profile-completeness", authenticate, getProfileCompleteness);
router.get("/security-audit", authenticate, getAccountSecurityAudit);
router.get("/email-aliases", authenticate, getEmailAliases);
router.post("/email-aliases", authenticate, addEmailAlias);
router.delete("/email-aliases", authenticate, removeEmailAlias);

router.get("/trusted-devices", authenticate, getTrustedDevices);
router.patch("/device/:deviceId/rename", authenticate, renameTrustedDevice);
router.post("/device/location", authenticate, registerDeviceLocation);

export default router;
