import { Request, Response, NextFunction } from "express";

/**
 * Wraps asynchronous Express middleware and route handlers to catch promise rejections.
 * Automatically passes any caught errors down to the global error handler via next().
 */
export const asyncHandler =
  (fn: (req: Request, res: Response, next: NextFunction) => Promise<any>) =>
  (req: Request, res: Response, next: NextFunction): void => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
