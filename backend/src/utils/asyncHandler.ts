import { Request, Response, NextFunction } from "express";

/**
 * Wraps asynchronous Express middleware and route handlers to catch promise rejections.
 * Automatically passes any caught errors down to the global error handler via next().
 * Optionally logs unhandled promise rejections before passing to next.
 * 
 * @param fn - The async function to wrap
 * @param logErrors - Boolean to toggle error logging (default false)
 */
export const asyncHandler =
  (fn: (req: Request, res: Response, next: NextFunction) => Promise<any>, logErrors: boolean = false) =>
  (req: Request, res: Response, next: NextFunction): void => {
    Promise.resolve(fn(req, res, next)).catch((err) => {
      if (logErrors) {
        console.error(`[AsyncHandler Error] Path: ${req.path}`, err);
      }
      next(err);
    });
  };
