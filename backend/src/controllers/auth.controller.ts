import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthService } from "../services/auth.service";
import { generateToken, AuthenticatedRequest } from "../middleware/auth";
import { ApiError } from "../utils/ApiError";

const authService = new AuthService();

/**
 * Handles user registration requests.
 * Expects email, password, and name in the request body.
 */
export const register = asyncHandler(async (req: Request, res: Response) => {
  const { email, password, name } = req.body;

  if (!email || !email.includes('@')) {
    throw ApiError.badRequest("A valid email address is required");
  }

  if (!password || password.length < 6) {
    throw ApiError.badRequest("Password must be at least 6 characters long");
  }

  if (!name || name.trim().length === 0) {
    throw ApiError.badRequest("Name is required and cannot be empty");
  }

  const user = await authService.register(email, password, name);
  const token = generateToken(user.id);

  res.status(201).json({
    success: true,
    message: "User registered successfully. Welcome to JobPilot AI!",
    data: { user, token },
  });
});

/**
 * Handles user login requests.
 * Expects email and password in the request body.
 */
export const login = asyncHandler(async (req: Request, res: Response) => {
  const { email, password } = req.body;

  if (!email || typeof email !== 'string' || !email.includes('@')) {
    throw ApiError.badRequest("A valid email address is required for login");
  }

  if (!password || typeof password !== 'string') {
    throw ApiError.badRequest("Password is required for login");
  }

  const user = await authService.login(email.toLowerCase().trim(), password);
  const token = generateToken(user.id);

  res.status(200).json({
    success: true,
    message: "Login successful. Welcome back!",
    data: { user, token },
  });
});

/**
 * Retrieves the currently authenticated user's profile information.
 */
export const getMe = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;

  const user = await authService.getMe(userId);

  res.status(200).json({
    success: true,
    message: "Current user fetched successfully",
    data: { user },
  });
});

/**
 * Handles user logout requests.
 * Invalidates the current session token if possible, or lets the client clear it.
 */
export const logout = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  // Potential server-side logout logic here (e.g. invalidating refresh token or redis session)
  // await authService.logout(userId);
  
  res.status(200).json({
    success: true,
    message: "Logged out successfully. Have a great day!",
    data: null,
  });
});

export const deleteAccount = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  await authService.deleteAccount(userId);
  
  res.status(200).json({
    success: true,
    message: "Account permanently deleted successfully",
    data: null,
  });
});

export const updatePassword = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { oldPassword, newPassword } = req.body;
  
  if (!oldPassword || !newPassword) {
    throw ApiError.badRequest("Both old and new passwords are required");
  }

  if (newPassword.length < 6) {
    throw ApiError.badRequest("New password must be at least 6 characters long");
  }

  await authService.updatePassword(userId, oldPassword, newPassword);
  
  res.status(200).json({
    success: true,
    message: "Password updated successfully",
    data: null,
  });
});

export const updateEmail = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { newEmail } = req.body;
  
  if (!newEmail || typeof newEmail !== 'string' || !newEmail.includes('@')) {
    throw ApiError.badRequest("A valid new email address is required");
  }

  const user = await authService.updateEmail(userId, newEmail.toLowerCase().trim());
  
  res.status(200).json({
    success: true,
    message: "Email address updated successfully",
    data: { user },
  });
});

export const updateName = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { newName } = req.body;
  
  if (!newName || typeof newName !== 'string' || newName.trim().length === 0) {
    throw ApiError.badRequest("A valid new name is required");
  }

  const user = await authService.updateName(userId, newName.trim());
  
  res.status(200).json({
    success: true,
    message: "Profile name updated successfully",
    data: { user },
  });
});

export const getActiveSessions = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  // Extract client IP (e.g. from x-forwarded-for or connection)
  const clientIp = req.headers['x-forwarded-for']?.toString() || req.socket.remoteAddress;
  
  const sessions = await authService.getActiveSessions(userId, clientIp);
  
  res.status(200).json({
    success: true,
    message: "Active sessions fetched successfully",
    data: sessions,
  });
});

export const getLoginHistory = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const history = await authService.getLoginHistory(userId);
  
  res.status(200).json({
    success: true,
    message: "Login history fetched successfully",
    data: history,
  });
});

export const registerDevice = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { fingerprint, deviceName } = req.body;
  
  const result = await authService.registerDeviceFingerprint(userId, fingerprint, deviceName);
  
  res.status(200).json({
    success: true,
    message: "Device fingerprint registered successfully",
    data: result,
  });
});

export const initiateMfaSetup = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const mfaData = await authService.initiateMfaSetup(userId);
  
  res.status(200).json({
    success: true,
    message: "MFA setup initiated successfully",
    data: mfaData,
  });
});

export const verifyMfaSetup = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { code } = req.body;
  
  const mfaData = await authService.verifyMfaSetup(userId, code);
  
  res.status(200).json({
    success: true,
    message: "MFA setup verified successfully",
    data: mfaData,
  });
});

export const generateBackupCodes = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const backupData = await authService.generateBackupCodes(userId);
  
  res.status(200).json({
    success: true,
    message: "Backup codes generated successfully",
    data: backupData,
  });
});

export const initiatePasswordlessLogin = asyncHandler(async (req: Request, res: Response) => {
  const { email } = req.body;
  
  if (!email || typeof email !== 'string' || !email.includes('@')) {
    throw ApiError.badRequest("A valid email address is required");
  }

  const result = await authService.initiatePasswordlessLogin(email);
  
  res.status(200).json({
    success: true,
    message: "Passwordless login initiated",
    data: result,
  });
});

export const initiateSmsTwoFactor = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { phoneNumber } = req.body;
  
  if (!phoneNumber) {
     res.status(400).json({ success: false, message: "Phone number is required." });
     return;
  }
  
  const smsData = await authService.initiateSmsTwoFactor(userId, phoneNumber);
  
  res.status(200).json({
    success: true,
    message: "SMS 2FA initiated successfully",
    data: smsData,
  });
});

export const getLoginStreak = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const streakData = await authService.getLoginStreak(userId);
  
  res.status(200).json({
    success: true,
    message: "Login streak fetched successfully",
    data: streakData,
  });
});

export const revokeSession = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  const { sessionId } = req.params;
  
  if (!sessionId) {
     res.status(400).json({ success: false, message: "Session ID is required" });
     return;
  }
  
  const result = await authService.revokeSession(userId, sessionId);
  
  res.status(200).json({
    success: true,
    message: "Session revoked successfully",
    data: result,
  });
});

export const exportUserData = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;
  
  const exportedData = await authService.exportUserData(userId);
  
  res.status(200).json({
    success: true,
    message: "User data exported successfully",
    data: exportedData,
  });
});
