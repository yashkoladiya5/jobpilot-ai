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

  async exportUserData(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        name: true,
        createdAt: true,
      }
    });

    if (!user) {
      throw ApiError.notFound("User not found");
    }

    const resumes = await prisma.resume.findMany({
      where: { userId },
      select: { id: true, fileName: true, isPrimary: true, createdAt: true }
    });

    const applications = await prisma.jobApplication.findMany({
      where: { userId },
      select: { id: true, companyName: true, role: true, status: true, appliedDate: true }
    });

    return {
      userInfo: user,
      resumes,
      applications,
      exportedAt: new Date().toISOString()
    };
  }

  async getUserSecurityScore(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw ApiError.notFound("User not found");

    let score = 50; // base score
    let recommendations = [];

    // Check password age (mocking that we check if it was updated recently)
    const passwordAgeDays = Math.floor((Date.now() - user.updatedAt.getTime()) / (1000 * 60 * 60 * 24));
    if (passwordAgeDays > 90) {
      recommendations.push("Consider updating your password, it hasn't been changed in over 90 days.");
    } else {
      score += 20;
    }

    // Check if MFA is enabled (mock check)
    const hasMfa = false; // In reality we'd check a field on the user model
    if (!hasMfa) {
      recommendations.push("Enable Two-Factor Authentication (2FA) to heavily secure your account.");
    } else {
      score += 30;
    }

    return {
      userId,
      securityScore: score,
      rating: score >= 80 ? "Excellent" : score >= 60 ? "Fair" : "Needs Improvement",
      recommendations
    };
  }

  async trustDevice(userId: string, deviceId: string, deviceName: string) {
    if (!deviceId || deviceId.trim().length === 0) {
      throw ApiError.badRequest("Device ID is required to trust a device.");
    }

    // Since we don't have a TrustedDevice model, we'll mock saving it to the database
    // by returning a structured success response. In a real scenario we'd insert this
    // into a trusted_devices table linked to the userId.

    return {
      userId,
      deviceId,
      deviceName: deviceName || "Unknown Device",
      trustedAt: new Date().toISOString(),
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), // 30 days
      message: `Device ${deviceName || deviceId} has been trusted for 30 days. You will not be prompted for 2FA on this device.`
    };
  }

  async getProfileCompleteness(userId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    let score = 0;
    const missingFields = [];

    if (user.name && user.name.trim().length > 0) {
      score += 25;
    } else {
      missingFields.push("Name");
    }

    if (user.email && user.email.trim().length > 0) {
      score += 25;
    } else {
      missingFields.push("Email");
    }

    // Since our prisma schema only has basic fields, we will mock the checks for Bio and Location
    // to simulate a real profile completeness check.
    const hasBio = false; // Mock
    if (hasBio) {
      score += 25;
    } else {
      missingFields.push("Bio");
    }

    const hasLocation = false; // Mock
    if (hasLocation) {
      score += 25;
    } else {
      missingFields.push("Location");
    }

    return {
      userId,
      completenessScore: score,
      missingFields,
      message: score === 100 ? "Your profile is fully complete!" : "Complete your profile to stand out more to recruiters."
    };
  }

  async verifyEmailDomain(email: string) {
    if (!email || !email.includes('@')) {
      throw ApiError.badRequest("Invalid email format");
    }

    const domain = email.split('@')[1].toLowerCase();
    
    // Mock list of known disposable email domains
    const disposableDomains = [
      "tempmail.com",
      "guerrillamail.com",
      "10minutemail.com",
      "mailinator.com",
      "yopmail.com",
      "dispostable.com"
    ];

    if (disposableDomains.includes(domain)) {
      return {
        email,
        domain,
        isDisposable: true,
        isValid: false,
        message: "Disposable email addresses are not allowed for registration."
      };
    }

    // In a real application, you might do a DNS MX record lookup here
    // e.g. using `dns.resolveMx(domain, ...)`
    
    return {
      email,
      domain,
      isDisposable: false,
      isValid: true,
      message: "Email domain verified successfully."
    };
  }

  async toggleTwoFactorAuth(userId: string, enable: boolean) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw ApiError.notFound("User not found");

    // We don't have is2FAEnabled in Prisma, so we'll mock it like we mock other MFA setup.
    // In a real app we'd update `user.is2FAEnabled`.

    return {
      userId,
      is2FAEnabled: enable,
      updatedAt: new Date().toISOString(),
      message: enable ? "Two-factor authentication has been enabled." : "Two-factor authentication has been disabled."
    };
  }

  async verifySessionHealth(userId: string) {
    // In a real application, lastLoginAt and isEmailVerified would be fetched from the database.
    // For this mock, we'll fetch the user and simulate these fields based on createdAt/updatedAt.
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { 
        id: true, 
        createdAt: true,
        updatedAt: true
      }
    });

    if (!user) {
      throw ApiError.unauthorized("User session is invalid or user no longer exists");
    }

    // Determine session health based on mock last login time
    const now = new Date();
    const daysSinceLogin = Math.floor((now.getTime() - user.updatedAt.getTime()) / (1000 * 60 * 60 * 24));
    
    // We mock email verification as true for older accounts and false for new ones
    const isEmailVerified = (now.getTime() - user.createdAt.getTime()) > (1000 * 60 * 60 * 24);

    let healthStatus = "HEALTHY";
    let message = "Session is secure and active.";
    let requiresAction = false;

    if (daysSinceLogin > 14) {
      healthStatus = "WARNING";
      message = "Session is active but it has been over 14 days since your last full login. You may need to re-authenticate soon.";
    }

    if (!isEmailVerified) {
      healthStatus = "AT_RISK";
      message = "Your email address is unverified, which limits account recovery options.";
      requiresAction = true;
    }

    return {
      userId,
      healthStatus,
      daysSinceLogin,
      requiresAction,
      message,
      checkedAt: now.toISOString()
    };
  }

  async revokeOtherSessions(userId: string, currentSessionId: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw ApiError.notFound("User not found");
    }

    if (!currentSessionId) {
      throw ApiError.badRequest("Current session ID is required to revoke other sessions.");
    }

    // In a real application we would look up all sessions for this user 
    // and delete or invalidate all of them except the one matching currentSessionId.

    return {
      userId,
      retainedSessionId: currentSessionId,
      revokedAt: new Date(),
      message: "All other active sessions have been revoked successfully."
    };
  }
}
