import { Request, Response, NextFunction } from "express";
import { ApiError } from "../utils/ApiError";
import { config } from "../config";
import { logger } from "../utils/logger";

export const errorHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (config.nodeEnv === "development") {
    logger.error("Error:", err);
  }

  if (err instanceof ApiError) {
    res.status(err.statusCode).json({
      success: false,
      message: err.message,
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
