import { Request, Response } from "express";
import { asyncHandler } from "../utils/asyncHandler";
import { AuthService } from "../services/auth.service";
import { generateToken, AuthenticatedRequest } from "../middleware/auth";

const authService = new AuthService();

export const register = asyncHandler(async (req: Request, res: Response) => {
  const { email, password, name } = req.body;

  const user = await authService.register(email, password, name);
  const token = generateToken(user.id);

  res.status(201).json({
    success: true,
    message: "User registered successfully",
    data: { user, token },
  });
});

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

export const getMe = asyncHandler(async (req: Request, res: Response) => {
  const userId = (req as AuthenticatedRequest).user.id;

  const user = await authService.getMe(userId);

  res.status(200).json({
    success: true,
    message: "User fetched successfully",
    data: { user },
  });
});
