import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import fs from "fs";
import morgan from "morgan";
import { routes } from "./routes";
import { errorHandler } from "./middleware/errorHandler";
import { config } from "./config";
import { logger } from "./utils/logger";
import { apiLimiter } from "./middleware/rateLimiter";

// Load environment variables from the .env file
dotenv.config();

// Ensure the file upload directory exists before accepting any uploads
fs.mkdirSync(config.uploadDir, { recursive: true });

// Initialize the Express application instance
const app = express();

// Enable Cross-Origin Resource Sharing (CORS) with configurable origin
app.use(cors({
  origin: config.corsOrigin,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
}));

// Parse incoming JSON payloads with size limits
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

const morganStream = { write: (message: string) => logger.http(message.trim()) };
app.use(morgan(":method :url :status :response-time ms - :res[content-length]", { stream: morganStream }));

if (config.enableRateLimiting) {
  logger.info("Rate limiting is enabled");
  app.use(config.apiPrefix, apiLimiter);
}

app.use(config.apiPrefix, routes);

app.use(errorHandler);

app.listen(config.port, "0.0.0.0", () => {
  logger.info(`Server running on 0.0.0.0:${config.port} in ${config.nodeEnv} mode`);
});
