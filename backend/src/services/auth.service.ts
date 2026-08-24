import bcrypt from "bcryptjs";
import prisma from "../config/prisma";
import { ApiError } from "../utils/ApiError";

const userSelect = {
  id: true,
  email: true,
  name: true,
  createdAt: true,
  updatedAt: true,
} as const;

/**
 * Handles business logic for user authentication, registration, and profile retrieval.
 */
export class AuthService {
  async register(email: string, password: string, name: string) {
    // Check if the provided email already exists in the system
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      throw ApiError.badRequest("Email already in use");
    }

    const passwordHash = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: { email, passwordHash, name },
      select: userSelect,
    });

    return user;
  }

  async login(email: string, password: string) {
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      throw ApiError.unauthorized("Invalid email or password");
    }

    const isMatch: boolean = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) {
      throw ApiError.unauthorized("Invalid email or password");
    }

    const { passwordHash: _, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  async getMe(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: userSelect,
    });

    if (!user) {
      throw ApiError.notFound("User not found in the system");
    }

    // Ensure the user account hasn't been deactivated
    if (user.email.endsWith('@deactivated.local')) {
      throw ApiError.forbidden("Your account has been deactivated. Please contact support.");
    }

    return user;
  }

  async updateProfile(userId: string, data: { name?: string; bio?: string }) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found in the system");
    }

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data,
      select: userSelect,
    });

    return updatedUser;
  }

  async deleteAccount(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found in the system");
    }

    // Instead of hard deleting, we might want to deactivate or hard delete
    // based on business logic. Let's hard delete for compliance (e.g. GDPR).
    await prisma.user.delete({
      where: { id: userId },
    });

    return { deletedId: userId };
  }

  async updatePassword(userId: string, oldPassword: string, newPassword: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    const isMatch: boolean = await bcrypt.compare(oldPassword, user.passwordHash);
    if (!isMatch) {
      throw ApiError.badRequest("Incorrect old password");
    }

    const passwordHash = await bcrypt.hash(newPassword, 10);
    
    await prisma.user.update({
      where: { id: userId },
      data: { passwordHash },
    });

    return { success: true };
  }

  async updateEmail(userId: string, newEmail: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    if (user.email === newEmail) {
      throw ApiError.badRequest("New email must be different from current email");
    }

    const existingUser = await prisma.user.findUnique({ where: { email: newEmail } });
    if (existingUser) {
      throw ApiError.badRequest("Email already in use by another account");
    }
    
    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: { email: newEmail },
      select: userSelect,
    });

    return updatedUser;
  }
}
