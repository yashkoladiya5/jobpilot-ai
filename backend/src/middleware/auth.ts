import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { config } from "../config";
import { ApiError } from "../utils/ApiError";

export interface AuthenticatedRequest extends Request {
  user: { id: string };
}

/**
 * Middleware to protect routes by verifying JWT tokens.
 * Extracts the user ID from the token and attaches it to the request object.
 */
export const authenticate = (
  req: Request,
  _res: Response,
  next: NextFunction
): void => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return next(ApiError.unauthorized("Authentication required"));
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, config.jwtSecret) as { userId: string };
    (req as AuthenticatedRequest).user = { id: decoded.userId };
    next();
  } catch {
    return next(ApiError.unauthorized("Invalid or expired token"));
  }
};

/**
 * Generates a new JWT for an authenticated user.
 * 
 * @param userId - The unique identifier of the user
 * @returns A signed JWT string
 */
export const generateToken = (userId: string): string => {
  return jwt.sign({ userId }, config.jwtSecret, {
    expiresIn: config.jwtExpiresIn as jwt.SignOptions["expiresIn"],
  });
};
