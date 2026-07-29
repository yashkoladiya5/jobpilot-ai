import dotenv from "dotenv";

// Load environment variables from the .env file into process.env
dotenv.config();

/**
 * Centralized configuration object for the backend application.
 * Parses and exports all required environment variables with default fallbacks.
 */
export const config = {
  port: parseInt(process.env.PORT || "3000", 10),
  databaseUrl: process.env.DATABASE_URL || "postgresql://postgres:postgres@localhost:5432/jobpilot_ai?schema=public",
  jwtSecret: process.env.JWT_SECRET || "your-super-secret-jwt-key-change-in-production",
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || "7d",
  uploadDir: process.env.UPLOAD_DIR || "./uploads",
  maxFileSize: parseInt(process.env.MAX_FILE_SIZE || "5242880", 10),
  nodeEnv: process.env.NODE_ENV || "development",
};
