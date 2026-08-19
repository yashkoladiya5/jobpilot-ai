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
  res: Response,
  next: NextFunction
): void => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return next(ApiError.unauthorized("Authentication required: Missing or invalid authorization header format"));
  }

  const token = authHeader.split(" ")[1];
  
  if (!token) {
    return next(ApiError.unauthorized("Authentication required: Token is missing"));
  }

  try {
    const decoded = jwt.verify(token, config.jwtSecret) as { userId: string, iat: number, exp: number };
    
    // Check if token is nearing expiration (e.g. less than 1 hour left)
    const currentTimestamp = Math.floor(Date.now() / 1000);
    if (decoded.exp && (decoded.exp - currentTimestamp < 3600)) {
      res.setHeader('X-Token-Expiring-Soon', 'true');
    }

    (req as AuthenticatedRequest).user = { id: decoded.userId };
    next();
  } catch (error) {
    return next(ApiError.unauthorized("Invalid or expired token. Please log in again."));
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
