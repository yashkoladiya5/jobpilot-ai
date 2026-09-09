import prisma from "../config/prisma";
import { ApiError } from "./ApiError";

/**
 * Loads the user with the given id or throws when it does not exist.
 */
export const requireUser = async (userId: string) => {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) {
    throw ApiError.notFound("User not found");
  }
  return user;
};