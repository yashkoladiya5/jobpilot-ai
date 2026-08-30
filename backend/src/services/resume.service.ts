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

  async getResumeVersionHistory(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    // Mock version history based on file modifications and duplication logic
    // In a real application we would track diffs or keep older file paths
    const now = new Date();
    
    const versionHistory = [
      {
        version: "v1.2 (Current)",
        date: resume.updatedAt,
        changes: ["Updated contact information", "Adjusted margins"],
        isActive: true
      },
      {
        version: "v1.1",
        date: new Date(now.getTime() - 1000 * 60 * 60 * 24 * 2), // 2 days ago
        changes: ["Added latest work experience", "Fixed typos"],
        isActive: false
      },
      {
        version: "v1.0 (Original)",
        date: resume.createdAt,
        changes: ["Initial upload"],
        isActive: false
      }
    ];

    return {
      resumeId: resume.id,
      fileName: resume.fileName,
      totalVersions: 3,
      history: versionHistory
    };
  }

  async getResumeQualityScore(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    // Mock an ATS quality score calculation
    // A larger file might imply more content (up to a point)
    let baseScore = 40;
    
    // Size check
    if (resume.fileSize > 50000 && resume.fileSize < 200000) baseScore += 25; // "Sweet spot" size
    else if (resume.fileSize >= 200000) baseScore += 15;
    else baseScore += 10;
    
    // Type check
    if (resume.mimeType === "application/pdf") baseScore += 20; // PDFs parse well usually
    else if (resume.mimeType === "application/vnd.openxmlformats-officedocument.wordprocessingml.document") baseScore += 15;
    
    // Name check
    if (!resume.fileName.toLowerCase().includes("untitled") && resume.fileName.length > 5) {
      baseScore += 15;
    }
    
    // Cap it
    let totalScore = Math.min(100, baseScore);
    
    return {
      resumeId: resume.id,
      fileName: resume.fileName,
      qualityScore: totalScore,
      rating: totalScore >= 80 ? "Excellent" : totalScore >= 60 ? "Good" : "Needs Work",
      suggestions: [
        totalScore < 100 ? "Ensure you use action verbs for bullet points." : "Your resume format looks ATS-friendly.",
        resume.mimeType !== "application/pdf" ? "Consider saving your resume as a PDF to preserve formatting." : "PDF format is optimal for ATS systems.",
      ]
    };
  }

  async getAtsOptimizedText(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    // Mock extracting and cleaning text to be purely ATS friendly
    // In a real application, we would use pdf-parse, Tesseract, or an AI model 
    // to strip formatting, remove tables, and standardize section headers.
    
    const mockCleanedText = `JOHN DOE
john.doe@email.com | (555) 123-4567 | linkedin.com/in/johndoe

SUMMARY
Experienced software engineer with 5 years of experience in full-stack development...

EXPERIENCE
Senior Developer, TechNova Inc. (Jan 2020 - Present)
- Developed RESTful APIs using Node.js and Express
- Optimized database queries resulting in 30% faster load times

EDUCATION
B.S. Computer Science, State University (2015 - 2019)

SKILLS
JavaScript, TypeScript, React, Node.js, SQL, AWS`;

    return {
      resumeId: resume.id,
      fileName: resume.fileName,
      optimizedText: mockCleanedText,
      warningCount: 0,
      warnings: [],
      message: "Resume successfully parsed into ATS-friendly plain text format."
    };
  }

  async analyzeMissingKeywords(userId: string, id: string, targetJobDescription: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    if (!targetJobDescription || targetJobDescription.trim().length < 50) {
      throw ApiError.badRequest("Target job description is too short to analyze.");
    }

    // Mock extracting keywords from JD and comparing with Resume
    const lowerJd = targetJobDescription.toLowerCase();
    
    // Some common keywords we look for
    const possibleKeywords = [
      "react", "node.js", "python", "sql", "aws", "docker", "kubernetes",
      "leadership", "agile", "scrum", "communication", "typescript", "graphql"
    ];
    
    const requiredByJd = possibleKeywords.filter(kw => lowerJd.includes(kw));
    
    // Mock resume content (in a real scenario we parse the PDF)
    const mockResumeContent = "I know React, TypeScript, and SQL. I have leadership experience.";
    const lowerResume = mockResumeContent.toLowerCase();

    const missingKeywords = requiredByJd.filter(kw => !lowerResume.includes(kw));
    const matchedKeywords = requiredByJd.filter(kw => lowerResume.includes(kw));

    return {
      resumeId: resume.id,
      fileName: resume.fileName,
      missingKeywords,
      matchedKeywords,
      matchPercentage: requiredByJd.length > 0 
        ? Math.round((matchedKeywords.length / requiredByJd.length) * 100) 
        : 100,
      recommendation: missingKeywords.length > 0
        ? `Consider adding these keywords to your resume to pass ATS: ${missingKeywords.join(', ')}.`
        : "Your resume contains all the core keywords we detected in the job description."
    };
  }

  async translateResume(userId: string, id: string, targetLanguage: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    if (!targetLanguage || targetLanguage.trim() === "") {
      throw ApiError.badRequest("Target language is required");
    }

    const validLanguages = ["spanish", "french", "german", "mandarin", "japanese"];
    const lang = targetLanguage.toLowerCase();
    
    if (!validLanguages.includes(lang)) {
      throw ApiError.badRequest(`Unsupported language. Supported languages: ${validLanguages.join(', ')}`);
    }

    // Mock AI translation of the resume
    let translatedSnippet = "";
    if (lang === "spanish") translatedSnippet = "RESUMEN: Ingeniero de software experimentado con 5 años...";
    else if (lang === "french") translatedSnippet = "RÉSUMÉ: Ingénieur logiciel expérimenté avec 5 ans...";
    else translatedSnippet = `[Translated to ${targetLanguage}]: Experienced software engineer...`;

    return {
      resumeId: resume.id,
      originalFileName: resume.fileName,
      targetLanguage,
      translatedContent: translatedSnippet,
      message: `Resume successfully translated into ${targetLanguage}.`
    };
  }

  async trackResumeView(userId: string, id: string, source: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    // In a real database, we would have a ResumeView table to record the views.
    // For this demonstration, we'll return a mock view count and log event.
    const newViewCount = Math.floor(Math.random() * 100) + 1;
    
    const viewLog = {
      resumeId: resume.id,
      viewedAt: new Date(),
      source: source || "direct_link",
      totalViewsMock: newViewCount,
      message: `Resume view tracked successfully from source: ${source || "direct_link"}`
    };

    return viewLog;
  }

  async generateShareableLink(userId: string, id: string, expiresInDays: number = 7) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    // In a real application, we would generate a secure token and store it in the database
    // along with the expiration date and resume ID.
    // For this mock, we generate a random string and return a simulated URL.
    
    const randomToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    const expirationDate = new Date();
    expirationDate.setDate(expirationDate.getDate() + expiresInDays);

    return {
      resumeId: resume.id,
      fileName: resume.fileName,
      shareableLink: `https://jobpilot.ai/shared/resume/${randomToken}`,
      expiresAt: expirationDate.toISOString(),
      message: `Shareable link generated successfully, valid for ${expiresInDays} days.`
    };
  }

  async generateResumeSummary(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    // Mock an AI generated summary of the resume
    const summary = "This resume highlights a strong background in software engineering, specifically in frontend development with React and TypeScript. It showcases 5+ years of experience leading teams and delivering high-quality web applications.";

    return {
      resumeId: resume.id,
      fileName: resume.fileName,
      summary,
      generatedAt: new Date().toISOString()
    };
  }

  async exportResumeAsJson(userId: string, id: string) {
    const resume = await prisma.resume.findFirst({
      where: { id, userId },
      include: {
        analyses: true
      }
    });

    if (!resume) {
      throw ApiError.notFound("Resume not found");
    }

    // Format the resume data into a standardized JSON structure
    // This allows users to export their parsed resume data to use on other platforms
    const parsedContent: any = resume.parsedContent && typeof resume.parsedContent === 'string' 
      ? JSON.parse(resume.parsedContent) 
      : resume.parsedContent || {};
      
    const exportData = {
      basics: {
        name: parsedContent.name || "Unknown",
        email: parsedContent.email || "",
        phone: parsedContent.phone || ""
      },
      work: parsedContent.experience || [],
      education: parsedContent.education || [],
      skills: parsedContent.skills || [],
      metadata: {
        lastUpdated: resume.updatedAt,
        latestScore: resume.analyses?.[0]?.overallScore || null
      }
    };

    return exportData;
  }

  async cloneResume(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    const newFileName = `${resume.fileName} (Clone)`;
    const newFilePath = `${resume.filePath}_clone_${Date.now()}`;
    
    try {
      fs.copyFileSync(resume.filePath, newFilePath);
    } catch (e) {
      throw ApiError.internal("Failed to clone resume file");
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

  async generateJobTitleMatchReport(userId: string, id: string, jobTitle: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    if (!jobTitle || jobTitle.trim().length === 0) {
      throw ApiError.badRequest("Job title is required for a match report.");
    }

    // Mocking the match report logic based on common patterns
    const titleLower = jobTitle.toLowerCase();
    
    // We mock checking if the job title appears in the user's resume content
    let matchScore = 50 + Math.floor(Math.random() * 45); // 50-95
    
    const keySkillsExpected = ["Communication", "Problem Solving"];
    if (titleLower.includes("engineer") || titleLower.includes("developer")) {
      keySkillsExpected.push("Coding", "System Design", "Version Control");
    } else if (titleLower.includes("manager")) {
      keySkillsExpected.push("Leadership", "Project Management", "Agile");
    }

    return {
      resumeId: resume.id,
      fileName: resume.fileName,
      targetJobTitle: jobTitle,
      overallMatchScore: matchScore,
      keySkillsExpected,
      recommendation: matchScore > 80 
        ? "Your resume is highly targeted for this role."
        : "Consider tailoring your resume headline and summary to better reflect this specific job title.",
      reportGeneratedAt: new Date().toISOString()
    };
  }

  async exportResumeAsPdf(userId: string, id: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    // In a real application, we would use a library like puppeteer or pdfkit
    // to generate a PDF from the resume data. For this mock, we just return a URL.
    
    // Simulate generation time
    const pdfUrl = `https://jobpilot.ai/downloads/${userId}/${id}/resume_exported.pdf`;

    return {
      resumeId: resume.id,
      originalFileName: resume.fileName,
      pdfUrl,
      generatedAt: new Date().toISOString(),
      message: "Resume successfully exported as PDF."
    };
  }

  async generateResumeVariations(userId: string, id: string, variationType: string) {
    const resume = await prisma.resume.findUnique({ where: { id } });
    
    if (!resume || resume.userId !== userId) {
      throw ApiError.notFound("Resume not found");
    }

    if (!variationType) {
      throw ApiError.badRequest("Variation type is required (e.g., 'technical', 'leadership', 'creative')");
    }

    // Mock AI generating a variation of the resume
    const newFileName = `${resume.fileName} (${variationType} variation)`;
    const newFilePath = `${resume.filePath}_var_${variationType}_${Date.now()}`;
    
    try {
      // In reality, we'd take the parsed text, rewrite it with an LLM, and generate a new PDF.
      // Here we just copy the file as a placeholder.
      fs.copyFileSync(resume.filePath, newFilePath);
    } catch (e) {
      throw ApiError.internal("Failed to generate resume variation file");
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

  async bulkDeleteResumes(userId: string, resumeIds: string[]) {
    if (!resumeIds || resumeIds.length === 0) {
      throw ApiError.badRequest("No resume IDs provided for bulk deletion");
    }

    const resumes = await prisma.resume.findMany({
      where: {
        id: { in: resumeIds },
        userId
      }
    });

    if (resumes.length === 0) {
      return { count: 0, message: "No matching resumes found to delete." };
    }

    let deletedCount = 0;
    for (const resume of resumes) {
      try {
        fs.unlinkSync(resume.filePath);
      } catch {
        // file may already be deleted, continue
      }
      await prisma.resume.delete({ where: { id: resume.id } });
      deletedCount++;
    }

    return { 
      count: deletedCount,
      message: `Successfully deleted ${deletedCount} resumes.`
    };
  }
}
