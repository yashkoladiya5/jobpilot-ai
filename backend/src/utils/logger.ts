import winston from "winston";
import { config } from "../config";

/**
 * Pre-configured Winston logger setup for standardizing application logs.
 * Supports different log formats based on the environment (dev vs prod).
 */
const levels = { error: 0, warn: 1, info: 2, http: 3, debug: 4 };
const level = config.nodeEnv === "development" ? "debug" : "warn";

const format = winston.format.combine(
  winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss.SSS" }), // Added milliseconds
  winston.format.errors({ stack: true }),
  winston.format.splat(), // Add support for string interpolation
  config.nodeEnv === "development"
    ? winston.format.combine(
        winston.format.colorize({ all: true }),
        winston.format.printf(({ timestamp, level, message, stack, ...meta }) => {
          const metaString = Object.keys(meta).length ? `\nMeta: ${JSON.stringify(meta)}` : '';
          return stack 
            ? `[${timestamp}] ${level}: ${message}${metaString}\n${stack}` 
            : `[${timestamp}] ${level}: ${message}${metaString}`;
        })
      )
    : winston.format.json(),
);

export const logger = winston.createLogger({
  level,
  levels,
  format,
  transports: [new winston.transports.Console()],
});
