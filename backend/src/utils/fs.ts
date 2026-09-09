import { readFile } from "fs/promises";

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