import rateLimit from "express-rate-limit";

interface RateLimitConfig {
  windowMs: number;
  max: number;
  message: string;
}

const createLimiter = ({ windowMs, max, message }: RateLimitConfig) =>
  rateLimit({
    windowMs,
    max,
    standardHeaders: true,
    legacyHeaders: false,
    message: { success: false, message, data: null },
  });

/**
 * Limits the number of authentication attempts to prevent brute-force attacks.
 */
export const authLimiter = createLimiter({
  windowMs: 15 * 60 * 1000,
  max: 10,
  message: "Too many attempts. Please try again after 15 minutes.",
});

export const apiLimiter = createLimiter({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: "Too many requests. Please try again later.",
});

export const uploadLimiter = createLimiter({
  windowMs: 60 * 60 * 1000, // 1 hour window
  max: 20, // limit each IP to 20 uploads per hour
  message: "Upload limit exceeded. Please try again after an hour.",
});

export const aiLimiter = createLimiter({
  windowMs: 60 * 60 * 1000, // 1 hour window
  max: 50, // limit each IP to 50 AI requests per hour
  message: "AI processing limit exceeded. Please wait before analyzing again.",
});
