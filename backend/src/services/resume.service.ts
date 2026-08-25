import fs from "fs";
import prisma from "../config/prisma";
import { ApiError } from "../utils/ApiError";

/**
 * Service managing user resumes, including file storage operations and database records.
 */
export class ResumeService {
  async uploadResume(userId: string, file: Express.Multer.File) {
    // Make the first uploaded resume primary by default
    const count = await prisma.resume.count({ where: { userId } });

    const resume = await prisma.resume.create({
      data: {
        userId,
        fileName: file.originalname,
        filePath: file.path,
        fileSize: file.size,
        mimeType: file.mimetype,
        isPrimary: count === 0,
      },
    });

    return resume;
  }

  async getResumes(userId: string) {
    return prisma.resume.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
  }

  async getResumeById(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });

    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    return resume;
  }

  async deleteResume(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });

    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    try {
      fs.unlinkSync(resume.filePath);
    } catch {
      // file may already be deleted, continue
    }

    await prisma.resume.delete({ where: { id } });
  }

  async setPrimaryResume(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }
    await prisma.resume.updateMany({
      where: { userId, isPrimary: true },
      data: { isPrimary: false },
    });
    return prisma.resume.update({
      where: { id },
      data: { isPrimary: true },
    });
  }

  async renameResume(userId: string, id: string, newName: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    return prisma.resume.update({
      where: { id },
      data: { fileName: newName },
    });
  }

  async getPrimaryResume(userId: string) {
    const resume = await prisma.resume.findFirst({
      where: { userId, isPrimary: true },
    });

    if (!resume) {
      throw ApiError.notFound("No primary resume found for this user");
    }

    return resume;
  }

  async duplicateResume(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    const newFileName = `Copy of ${resume.fileName}`;
    const newFilePath = `${resume.filePath}_copy_${Date.now()}`;
    
    try {
      fs.copyFileSync(resume.filePath, newFilePath);
    } catch (e) {
      throw ApiError.internal("Failed to duplicate resume file");
    }

    return prisma.resume.create({
      data: {
        userId,
        fileName: newFileName,
        filePath: newFilePath,
        fileSize: resume.fileSize,
        mimeType: resume.mimeType,
        isPrimary: false,
      },
    });
  }

  async getResumeStats(userId: string) {
    const resumes = await prisma.resume.findMany({
      where: { userId },
      select: {
        id: true,
        fileSize: true,
        createdAt: true,
      }
    });

    const totalCount = resumes.length;
    let totalStorageBytes = 0;
    
    resumes.forEach(r => {
      totalStorageBytes += r.fileSize;
    });

    // Calculate how many resumes were uploaded in the last 30 days
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    const recentUploads = resumes.filter(r => r.createdAt >= thirtyDaysAgo).length;

    return {
      totalCount,
      totalStorageBytes,
      recentUploads,
      storageUsedMb: Number((totalStorageBytes / (1024 * 1024)).toFixed(2)),
      storageLimitMb: 50, // Mock limit
    };
  }

  async getRecentResumeActivity(userId: string) {
    const resumes = await prisma.resume.findMany({
      where: { userId },
      select: {
        id: true,
        fileName: true,
        createdAt: true,
        updatedAt: true,
      },
      orderBy: { updatedAt: "desc" },
      take: 10
    });

    return resumes.map(r => {
      let activityType = "Updated";
      if (r.createdAt.getTime() === r.updatedAt.getTime()) {
        activityType = "Uploaded";
      } else if (r.fileName.startsWith("Copy of")) {
        activityType = "Duplicated";
      }
      
      return {
        id: r.id,
        fileName: r.fileName,
        activityType,
        timestamp: r.updatedAt
      };
    });
  }
}
