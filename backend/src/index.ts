import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import morgan from "morgan";
import { routes } from "./routes";
import { errorHandler } from "./middleware/errorHandler";
import { config } from "./config";
import { logger } from "./utils/logger";
import { apiLimiter } from "./middleware/rateLimiter";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const morganStream = { write: (message: string) => logger.http(message.trim()) };
app.use(morgan(":method :url :status :response-time ms", { stream: morganStream }));

app.use("/api", apiLimiter);
app.use("/api", routes);

app.use(errorHandler);

app.listen(config.port, "0.0.0.0", () => {
  logger.info(`Server running on 0.0.0.0:${config.port} in ${config.nodeEnv} mode`);
});
