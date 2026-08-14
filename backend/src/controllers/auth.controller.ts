import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthService } from "../services/auth.service";
import { generateToken, AuthenticatedRequest } from "../middleware/auth";

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

  const user = await authService.login(email, password);
  const token = generateToken(user.id);

  res.status(200).json({
    success: true,
    message: "Login successful",
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
