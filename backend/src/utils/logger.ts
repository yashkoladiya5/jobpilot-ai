import winston from "winston";
import { config } from "../config";

const levels = { error: 0, warn: 1, info: 2, http: 3, debug: 4 };
const level = config.nodeEnv === "development" ? "debug" : "warn";

const format = winston.format.combine(
  winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss" }),
  winston.format.errors({ stack: true }),
  config.nodeEnv === "development"
    ? winston.format.combine(
        winston.format.colorize(),
        winston.format.printf(({ timestamp, level, message, stack }) =>
          stack ? `${timestamp} ${level}: ${message}\n${stack}` : `${timestamp} ${level}: ${message}`
        )
      )
    : winston.format.json(),
);

export const logger = winston.createLogger({
  level,
  levels,
  format,
  transports: [new winston.transports.Console()],
});
