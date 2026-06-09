import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { routes } from "./routes";
import { errorHandler } from "./middleware/errorHandler";
import { config } from "./config";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api", routes);

app.use(errorHandler);

app.listen(config.port, "0.0.0.0", () => {
  console.log(`Server running on 0.0.0.0:${config.port} in ${config.nodeEnv} mode`);
});
