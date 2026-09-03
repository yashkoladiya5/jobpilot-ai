import multer from "multer";
import path from "path";
import { v4 as uuidv4 } from "uuid";
import { config } from "../config";
import { ApiError } from "../utils/ApiError";
import { logger } from "../utils/logger";

/**
 * Disk storage configuration for uploaded files.
 * Uses UUIDs for filenames to prevent collisions.
 */
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, config.uploadDir);
  },
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    cb(null, `${uuidv4()}${ext}`);
  },
});

const allowedMimeTypes = [
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "text/plain", // Adding basic text format support
];

const fileFilter = (
  _req: Express.Request,
  file: Express.Multer.File,
  cb: multer.FileFilterCallback
) => {
  if (allowedMimeTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    logger.warn(`[Upload] Rejected file: ${file.originalname} (${file.mimetype}) - Unauthorized format`);
    cb(ApiError.badRequest(`Unsupported file format '${file.mimetype}'. Only PDF, DOC, DOCX, and TXT files are allowed`));
  }
};

/**
 * Multer configuration for handling file uploads safely.
 * Restricts files to document formats (PDF, DOC, DOCX) and enforces size limits.
 */
export const upload = multer({
  storage,
  fileFilter,
  limits: { fileSize: config.maxFileSize },
});
