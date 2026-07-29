import { Request, Response, NextFunction } from "express";
import { ZodSchema, ZodError } from "zod";

/**
 * Generic validation middleware using Zod schemas.
 * Intercepts requests, parses the body/query/params against a given schema,
 * and returns formatted errors if validation fails.
 */
export const validate = (schema: ZodSchema) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      schema.parse({
        body: req.body,
        params: req.params,
        query: req.query,
      });
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const errors = error.errors.map((e) => ({
          field: e.path.join("."),
          message: e.message,
        }));

        res.status(400).json({
          success: false,
          message: "Validation failed",
          errors,
          data: null,
        });
        return;
      }
      next(error);
    }
  };
};
