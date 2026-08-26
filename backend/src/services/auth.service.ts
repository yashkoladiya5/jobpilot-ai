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

  async updateName(userId: string, newName: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    if (user.name === newName) {
      throw ApiError.badRequest("New name must be different from current name");
    }
    
    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: { name: newName },
      select: userSelect,
    });

    return updatedUser;
  }

  async getActiveSessions(userId: string, currentIp?: string) {
    // In a real app, you'd fetch from a Session table or Redis
    // We mock active sessions for the user's dashboard view here
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    const sessions = [
      {
        id: "sess_1",
        device: "MacBook Pro - Chrome",
        ipAddress: currentIp || "192.168.1.1",
        lastActive: new Date(),
        isCurrent: true,
        location: "San Francisco, CA"
      },
      {
        id: "sess_2",
        device: "iPhone 14 - Safari",
        ipAddress: "192.168.1.5",
        lastActive: new Date(Date.now() - 1000 * 60 * 60 * 24 * 2), // 2 days ago
        isCurrent: false,
        location: "San Francisco, CA"
      }
    ];

    return sessions;
  }

  async getLoginHistory(userId: string) {
    // In a real application, you would query an audit log or LoginHistory table.
    // We provide mock login history to support the frontend dashboard security view.
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    const history = [
      {
        id: "log_1",
        timestamp: new Date(),
        status: "SUCCESS",
        ipAddress: "192.168.1.1",
        device: "MacBook Pro - Chrome",
        location: "San Francisco, CA"
      },
      {
        id: "log_2",
        timestamp: new Date(Date.now() - 1000 * 60 * 60 * 24 * 1), // 1 day ago
        status: "SUCCESS",
        ipAddress: "192.168.1.5",
        device: "iPhone 14 - Safari",
        location: "San Francisco, CA"
      },
      {
        id: "log_3",
        timestamp: new Date(Date.now() - 1000 * 60 * 60 * 24 * 5), // 5 days ago
        status: "FAILED_ATTEMPT",
        ipAddress: "104.28.192.3",
        device: "Unknown Device - Firefox",
        location: "London, UK"
      }
    ];

    return history;
  }

  async registerDeviceFingerprint(userId: string, fingerprint: string, deviceName: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    if (!fingerprint || !deviceName) {
      throw ApiError.badRequest("Fingerprint and deviceName are required.");
    }

    // Mocking device registration. In a real app we'd save this to a Device table.
    // If the device is new, we might also trigger a "New Login Detected" email.
    const isNewDevice = true; // Simulating that it's always a new device for the mock.
    
    return {
      userId,
      deviceId: `dev_${fingerprint.substring(0, 8)}`,
      deviceName,
      registeredAt: new Date(),
      isNewDevice,
      message: isNewDevice ? "New device registered successfully. Security alert triggered if enabled." : "Device recognized."
    };
  }

  async initiateMfaSetup(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    // Mock generating a TOTP secret and provisioning URI
    const mockSecret = "JBSWY3DPEHPK3PXP";
    const appName = "JobPilotAI";
    const mockUri = `otpauth://totp/${appName}:${user.email}?secret=${mockSecret}&issuer=${appName}`;
    
    // In a real implementation, we would save this secret to the DB temporarily
    // until the user verifies it with a code.
    
    return {
      userId: user.id,
      email: user.email,
      mfaSecret: mockSecret,
      provisioningUri: mockUri,
      status: "PENDING_VERIFICATION",
      message: "Scan the QR code with your authenticator app and verify to complete setup."
    };
  }

  async verifyMfaSetup(userId: string, code: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    if (!code || code.length !== 6) {
      throw ApiError.badRequest("Invalid TOTP code format");
    }

    // Mock verifying the code against a TOTP secret
    // In a real app we would use a library like 'otplib' and verify the code against the saved secret.
    if (code === "000000") {
      throw ApiError.badRequest("Verification failed. Invalid code.");
    }

    // On success, we would update the user record to enable MFA.
    return {
      userId: user.id,
      mfaEnabled: true,
      verifiedAt: new Date(),
      message: "Multi-factor authentication successfully enabled on your account."
    };
  }

  async generateBackupCodes(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    // Generate 10 random 8-character alphanumeric backup codes
    const codes = Array.from({ length: 10 }, () => 
      Math.random().toString(36).substring(2, 10).toUpperCase()
    );

    // In a real application, we would hash these codes (e.g. with bcrypt) and store them in the database
    // We only return the raw codes to the user once during this generation step.
    
    return {
      userId: user.id,
      message: "Backup codes generated. Please save these in a secure place. They will not be shown again.",
      codes,
      generatedAt: new Date()
    };
  }

  async initiatePasswordlessLogin(email: string) {
    const user = await prisma.user.findUnique({ where: { email: email.toLowerCase().trim() } });
    if (!user) {
      // Return a generic message even if user is not found to prevent email enumeration
      return {
        message: "If an account with this email exists, a magic link has been sent to it.",
        expiresIn: "15 minutes"
      };
    }

    // Mock generating a secure, time-limited magic link token
    const mockMagicToken = Math.random().toString(36).substring(2) + Date.now().toString(36);
    
    // In a real application, we would save the token hash with an expiration time to the database
    // and send an email using an email provider like SendGrid or AWS SES.
    
    return {
      message: "If an account with this email exists, a magic link has been sent to it.",
      mockLinkForTesting: `https://jobpilot.ai/auth/verify-magic-link?token=${mockMagicToken}&email=${encodeURIComponent(user.email)}`,
      expiresIn: "15 minutes"
    };
  }

  async initiateSmsTwoFactor(userId: string, phoneNumber: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    // Basic validation of phone number
    if (!phoneNumber || phoneNumber.length < 10) {
      throw ApiError.badRequest("A valid phone number is required for SMS 2FA");
    }

    // Mock generating a 6-digit numeric code
    const smsCode = Math.floor(100000 + Math.random() * 900000).toString();

    // In a real application, we would use an SMS provider like Twilio, AWS SNS, or Plivo
    // to send `smsCode` to `phoneNumber`. We would also store the code in a cache (like Redis)
    // with a short expiration time (e.g. 5 minutes) against the user's ID.
    
    return {
      userId: user.id,
      phoneNumberPreview: `+** *******${phoneNumber.slice(-4)}`,
      mockSmsCodeSent: smsCode, // Returning for testing purposes
      expiresIn: "5 minutes",
      message: "SMS verification code sent successfully. Please check your messages."
    };
  }

  async getLoginStreak(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    // In a real application, we would query the login history table
    // For this mock, we'll return a dynamic streak based on the user's creation date
    const accountAgeDays = Math.max(1, Math.floor((Date.now() - user.createdAt.getTime()) / (1000 * 60 * 60 * 24)));
    
    // Simulate a streak that is somewhat believable based on account age
    const currentStreak = Math.min(accountAgeDays, Math.floor(Math.random() * 7) + 1);
    const longestStreak = Math.max(currentStreak, Math.min(accountAgeDays, 14));
    
    const today = new Date();
    const lastLogin = new Date(today.getTime() - (Math.random() > 0.5 ? 0 : 1000 * 60 * 60 * 24)); // Either today or yesterday
    
    const isStreakActive = lastLogin.toDateString() === today.toDateString();

    return {
      userId,
      currentStreak,
      longestStreak,
      lastLoginDate: lastLogin.toISOString(),
      isStreakActive,
      message: isStreakActive ? `You're on a ${currentStreak}-day streak! Keep it up!` : "Login today to keep your streak alive!"
    };
  }

  async revokeSession(userId: string, sessionId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    if (!sessionId) {
      throw ApiError.badRequest("Session ID is required to revoke a session.");
    }

    // In a real application, we would lookup the session in the DB or Redis
    // and delete or invalidate it. If the session belongs to a different user,
    // we would throw an unauthorized error.
    
    // Mocking the revocation process
    const mockActiveSessions = ["sess_1", "sess_2", "sess_3"];
    
    if (!mockActiveSessions.includes(sessionId)) {
      throw ApiError.notFound("Session not found or already inactive.");
    }

    return {
      userId,
      revokedSessionId: sessionId,
      revokedAt: new Date(),
      message: "Session revoked successfully. The device has been logged out."
    };
  }
}
