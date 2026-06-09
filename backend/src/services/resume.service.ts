import fs from "fs";
import prisma from "../config/prisma";
import { ApiError } from "../utils/ApiError";

export class ResumeService {
  async uploadResume(userId: string, file: Express.Multer.File) {
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
}
