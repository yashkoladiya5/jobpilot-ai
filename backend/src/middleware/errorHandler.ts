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

  const sendError = (statusCode: number, message: string) => {
    res.status(statusCode).json({
      success: false,
      message,
      errors: null,
      data: null,
    });
  };

  // Intercept explicit API errors and format their payload
  if (err instanceof ApiError) {
    sendError(err.statusCode, err.message);
    return;
  }

  // Body-parser tags malformed-JSON bodies with type 'entity.parse.failed'.
  // Other SyntaxErrors (e.g. from application code) indicate a server bug and
  // must not be misreported as a client-side 400 — let them fall through to the
  // 500 handler so they reach the error logger.
  if (
    err instanceof SyntaxError &&
    (err as { type?: string }).type === "entity.parse.failed"
  ) {
    sendError(400, "Invalid JSON format in the request body. Please verify the syntax.");
    return;
  }

  if (err.name === 'JsonWebTokenError') {
    sendError(401, "Invalid or malformed authentication token provided.");
    return;
  }

  if (err.name === 'TokenExpiredError') {
    sendError(401, "Authentication token has expired. Please log in again.");
    return;
  }

  if (err.name === 'ValidationError') {
    sendError(400, "Validation Error: " + err.message);
    return;
  }

  if (err instanceof MulterError) {
    const message =
      err.code === "LIMIT_FILE_SIZE"
        ? "File too large. Maximum size is 5MB."
        : err.message;
    sendError(400, message);
    return;
  }

  // Oversized bodies from express.json/express.urlencoded surface as body-parser
  // HttpError with type 'entity.too.large' (non-ApiError); return 413 not 500.
  if ((err as { type?: string }).type === 'entity.too.large') {
    sendError(413, "Request body is too large. Maximum allowed size is 10MB.");
    return;
  }

  // Enhanced unhandled error logging
  logger.error(`[Unhandled Error] ${err.name}: ${err.message}`, { stack: err.stack });

  sendError(500, "Internal Server Error");
};
