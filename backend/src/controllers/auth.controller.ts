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
