import { Request, Response, NextFunction } from "express";
import { MulterError } from "multer";
import { ApiError } from "../utils/ApiError";
import { config } from "../config";
import { logger } from "../utils/logger";

/**
 * Global error handling middleware for the Express application.
 * Catches ApiError instances, syntax errors, and Multer upload errors, formatting them consistently.
 */
export const errorHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (config.nodeEnv === "development") {
    logger.error("Error:", err);
  }

  // Intercept explicit API errors and format their payload
  if (err instanceof ApiError) {
    res.status(err.statusCode).json({
      success: false,
      message: err.message,
      errors: null,
      data: null,
    });
    return;
  }

  if (err instanceof SyntaxError) {
    res.status(400).json({
      success: false,
      message: "Invalid JSON format in the request body. Please verify the syntax.",
      errors: null,
      data: null,
    });
    return;
  }

  if (err.name === 'ValidationError') {
    res.status(400).json({
      success: false,
      message: "Validation Error: " + err.message,
      errors: null,
      data: null,
    });
    return;
  }

  // Enhanced unhandled error logging
  logger.error(`[Unhandled Error] ${err.name}: ${err.message}`, { stack: err.stack });

  if (err instanceof MulterError) {
    const message =
      err.code === "LIMIT_FILE_SIZE"
        ? "File too large. Maximum size is 5MB."
        : err.message;
    res.status(400).json({
      success: false,
      message,
      errors: null,
      data: null,
    });
    return;
  }

  res.status(500).json({
    success: false,
    message: "Internal Server Error",
    errors: null,
    data: null,
  });
};
