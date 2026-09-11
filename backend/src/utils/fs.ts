import { readFile } from "fs/promises";
import { ApiError } from "./ApiError";

/**
 * Reads a text file, returning `fallbackText` when the file cannot be read
 * (e.g. binary uploads or missing files).
 */
export const readTextFileSafely = async <T>(
  filePath: string,
  fallbackText: T,
): Promise<string | T> => {
  try {
    return await readFile(filePath, "utf-8");
  } catch {
    return fallbackText;
  }
};

/**
 * Reads a text file, throwing a 400 API error with the given message
 * when the file cannot be read.
 */
export const readTextFileOrThrow = async (
  filePath: string,
  message: string,
): Promise<string> => {
  try {
    return await readFile(filePath, "utf-8");
  } catch {
    throw ApiError.badRequest(message);
  }
};