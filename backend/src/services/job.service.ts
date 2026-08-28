import prisma from "../config/prisma";
import { ApiError } from "../utils/ApiError";

/**
 * Service handling all business logic and database interactions for Job Applications.
 */
export class JobService {
  async getJobs(
    userId: string,
    query?: {
      search?: string;
      status?: string;
      sortBy?: string;
      sortOrder?: string;
    }
  ) {
    // Initialize base query filtering by the authenticated user
    const where: any = { userId };
    if (query?.status) {
      where.status = query.status;
    }
    if (query?.search) {
      where.OR = [
        { companyName: { contains: query.search, mode: "insensitive" } },
        { role: { contains: query.search, mode: "insensitive" } },
      ];
    }
    let orderBy: any = { appliedDate: "desc" };
    if (query?.sortBy) {
      const validSortFields = ["appliedDate", "companyName", "status", "createdAt"];
      if (validSortFields.includes(query.sortBy)) {
        orderBy = { [query.sortBy]: query.sortOrder === "asc" ? "asc" : "desc" };
      }
    }
    return prisma.jobApplication.findMany({ where, orderBy });
  }

  async getJobById(userId: string, id: string) {
    const job = await prisma.jobApplication.findFirst({
      where: { id, userId },
    });

    if (!job) {
      throw ApiError.notFound("Job application not found");
    }

    return job;
  }

  async createJob(
    userId: string,
    data: {
      companyName: string;
      role: string;
      jobUrl?: string;
      salaryRange?: string;
      location?: string;
      status?: string;
      notes?: string;
      resumeId?: string;
    }
  ) {
    return prisma.jobApplication.create({
      data: {
        userId,
        companyName: data.companyName,
        role: data.role,
        jobUrl: data.jobUrl,
        salaryRange: data.salaryRange,
        location: data.location,
        status: (data.status ?? "SAVED") as "SAVED" | "APPLIED" | "INTERVIEW" | "OFFER" | "REJECTED" | "WITHDRAWN",
        notes: data.notes,
        resumeId: data.resumeId,
      },
    });
  }

  async updateJob(
    userId: string,
    id: string,
    data: Partial<{
      companyName: string;
      role: string;
      jobUrl: string;
      salaryRange: string;
      location: string;
      status: string;
      notes: string;
      resumeId: string;
    }>
  ) {
    await this.getJobById(userId, id);

    return prisma.jobApplication.update({
      where: { id },
      data: {
        companyName: data.companyName,
        role: data.role,
        jobUrl: data.jobUrl,
        salaryRange: data.salaryRange,
        location: data.location,
        notes: data.notes,
        ...(data.status ? { status: data.status as "SAVED" | "APPLIED" | "INTERVIEW" | "OFFER" | "REJECTED" | "WITHDRAWN" } : {}),
        ...(data.resumeId !== undefined ? { resumeId: data.resumeId } : {}),
      },
    });
  }

  async deleteJob(userId: string, id: string): Promise<void> {
    await this.getJobById(userId, id);

    await prisma.jobApplication.delete({
      where: { id },
    });
  }

  async updateJobStatus(userId: string, id: string, status: string) {
    const validStatuses = ["SAVED", "APPLIED", "INTERVIEW", "OFFER", "REJECTED", "WITHDRAWN"];
    if (!validStatuses.includes(status)) {
      throw ApiError.badRequest("Invalid job status provided");
    }

    await this.getJobById(userId, id);

    return prisma.jobApplication.update({
      where: { id },
      data: { status: status as any },
    });
  }

  async updateJobNote(userId: string, id: string, notes: string) {
    // We get the job to ensure it belongs to the user and exists
    await this.getJobById(userId, id);

    return prisma.jobApplication.update({
      where: { id },
      data: { notes },
    });
  }

  async archiveJob(userId: string, id: string) {
    const job = await this.getJobById(userId, id);
    
    // We mock archiving by prefixing the note and setting a terminal status
    const archivedNote = `[ARCHIVED on ${new Date().toISOString()}]\n${job.notes || ''}`;

    return prisma.jobApplication.update({
      where: { id },
      data: { 
        status: "WITHDRAWN", // Using a valid status from the schema as archive state
        notes: archivedNote 
      },
    });
  }

  async getJobsAnalytics(userId: string) {
    const jobs = await prisma.jobApplication.findMany({
      where: { userId },
      select: { status: true },
    });

    const analytics = {
      total: jobs.length,
      saved: jobs.filter(j => j.status === 'SAVED').length,
      applied: jobs.filter(j => j.status === 'APPLIED').length,
      interviewing: jobs.filter(j => j.status === 'INTERVIEW').length,
      offers: jobs.filter(j => j.status === 'OFFER').length,
      rejected: jobs.filter(j => j.status === 'REJECTED').length,
      withdrawn: jobs.filter(j => j.status === 'WITHDRAWN').length,
    };

    return analytics;
  }

  async bulkUpdateJobStatus(userId: string, jobIds: string[], status: string) {
    const validStatuses = ["SAVED", "APPLIED", "INTERVIEW", "OFFER", "REJECTED", "WITHDRAWN"];
    if (!validStatuses.includes(status)) {
      throw ApiError.badRequest("Invalid job status provided");
    }

    if (!jobIds || jobIds.length === 0) {
      throw ApiError.badRequest("No job IDs provided for bulk update");
    }

    const updated = await prisma.jobApplication.updateMany({
      where: { 
        id: { in: jobIds },
        userId 
      },
      data: { status: status as any },
    });

    return { count: updated.count };
  }

  async bulkDeleteJobs(userId: string, jobIds: string[]) {
    if (!jobIds || jobIds.length === 0) {
      throw ApiError.badRequest("No job IDs provided for bulk deletion");
    }

    const deleted = await prisma.jobApplication.deleteMany({
      where: { 
        id: { in: jobIds },
        userId 
      },
    });

    return { count: deleted.count };
  }

  async getJobsNeedingFollowUp(userId: string) {
    const fourteenDaysAgo = new Date();
    fourteenDaysAgo.setDate(fourteenDaysAgo.getDate() - 14);

    const jobs = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: { in: ["APPLIED", "INTERVIEW"] },
        updatedAt: { lte: fourteenDaysAgo }
      },
      orderBy: { updatedAt: "asc" },
      take: 10
    });

    return jobs.map(job => ({
      id: job.id,
      companyName: job.companyName,
      role: job.role,
      status: job.status,
      daysSinceLastUpdate: Math.floor((new Date().getTime() - job.updatedAt.getTime()) / (1000 * 60 * 60 * 24)),
      suggestedAction: job.status === "APPLIED" 
        ? "Send a polite follow-up email to the recruiter."
        : "Check in on your interview feedback."
    }));
  }

  async getJobNotesSummary(userId: string) {
    const jobsWithNotes = await prisma.jobApplication.findMany({
      where: {
        userId,
        notes: { not: null, not: "" }
      },
      select: {
        id: true,
        companyName: true,
        role: true,
        notes: true,
        updatedAt: true
      },
      orderBy: { updatedAt: "desc" },
      take: 20
    });

    const totalNotesLength = jobsWithNotes.reduce((acc, job) => acc + (job.notes?.length || 0), 0);

    return {
      totalJobsWithNotes: jobsWithNotes.length,
      averageNoteLength: jobsWithNotes.length > 0 ? Math.round(totalNotesLength / jobsWithNotes.length) : 0,
      recentNotes: jobsWithNotes.slice(0, 5)
    };
  }

  async getJobActionItems(userId: string) {
    const jobs = await prisma.jobApplication.findMany({
      where: { userId, status: { notIn: ["REJECTED", "WITHDRAWN", "SAVED"] } },
      orderBy: { updatedAt: "desc" },
    });

    const actionItems = [];
    const now = new Date().getTime();

    for (const job of jobs) {
      const daysSinceUpdate = Math.floor((now - job.updatedAt.getTime()) / (1000 * 60 * 60 * 24));
      
      if (job.status === "APPLIED" && daysSinceUpdate >= 7) {
        actionItems.push({
          jobId: job.id,
          company: job.companyName,
          role: job.role,
          type: "FOLLOW_UP",
          priority: daysSinceUpdate >= 14 ? "HIGH" : "MEDIUM",
          message: `It's been ${daysSinceUpdate} days since you applied. Consider sending a follow-up email.`
        });
      } else if (job.status === "INTERVIEW") {
        actionItems.push({
          jobId: job.id,
          company: job.companyName,
          role: job.role,
          type: "PREPARE",
          priority: "HIGH",
          message: "You have an active interview phase. Have you practiced your mock interviews recently?"
        });
      } else if (job.status === "OFFER" && daysSinceUpdate >= 3) {
        actionItems.push({
          jobId: job.id,
          company: job.companyName,
          role: job.role,
          type: "DECISION",
          priority: "HIGH",
          message: "You received an offer recently. Don't forget to negotiate or respond by the deadline."
        });
      }
    }

    return actionItems.slice(0, 5); // Return top 5 most relevant action items
  }

  async getJobApplicationVelocity(userId: string) {
    const fourWeeksAgo = new Date();
    fourWeeksAgo.setDate(fourWeeksAgo.getDate() - 28);
    
    const applications = await prisma.jobApplication.findMany({
      where: {
        userId,
        createdAt: { gte: fourWeeksAgo },
      },
      select: { createdAt: true },
    });

    const weeklyVelocity = [0, 0, 0, 0]; // Week 1 (oldest), Week 2, Week 3, Week 4 (current)
    const now = new Date().getTime();

    for (const app of applications) {
      const daysAgo = Math.floor((now - app.createdAt.getTime()) / (1000 * 60 * 60 * 24));
      
      if (daysAgo < 7) weeklyVelocity[3]++;
      else if (daysAgo < 14) weeklyVelocity[2]++;
      else if (daysAgo < 21) weeklyVelocity[1]++;
      else if (daysAgo < 28) weeklyVelocity[0]++;
    }

    const currentPace = weeklyVelocity[3];
    const previousPace = weeklyVelocity[2];
    
    let trend = "stable";
    if (currentPace > previousPace) trend = "increasing";
    else if (currentPace < previousPace) trend = "decreasing";

    return {
      totalLast4Weeks: applications.length,
      weeklyVelocity,
      currentPace,
      trend,
      message: trend === "decreasing" ? "Your application velocity has dropped recently. Try to submit a few more this week!" : "Great job maintaining your application momentum!"
    };
  }

  async getDeadlineReminders(userId: string) {
    // Find active jobs that might have an impending deadline (like an assignment or interview)
    const activeJobs = await prisma.jobApplication.findMany({
      where: { 
        userId, 
        status: { in: ["APPLIED", "INTERVIEW"] }
      },
      orderBy: { updatedAt: "desc" },
      take: 10
    });

    if (activeJobs.length === 0) {
      return {
        reminders: [],
        message: "No impending deadlines found for your active applications."
      };
    }

    const reminders = [];
    
    // Mock analyzing notes for dates or deadlines
    for (const job of activeJobs) {
      const lowerNotes = (job.notes || "").toLowerCase();
      
      let type = "General Follow Up";
      let urgency = "Low";
      let daysLeft = Math.floor(Math.random() * 10) + 1; // Mock 1 to 10 days
      
      if (lowerNotes.includes("assignment") || lowerNotes.includes("take-home") || lowerNotes.includes("test")) {
        type = "Assessment Deadline";
        urgency = "High";
        daysLeft = Math.floor(Math.random() * 3) + 1; // Mock 1 to 3 days
      } else if (job.status === "INTERVIEW") {
        type = "Upcoming Interview";
        urgency = "High";
        daysLeft = Math.floor(Math.random() * 5) + 1; // Mock 1 to 5 days
      }

      reminders.push({
        jobId: job.id,
        companyName: job.companyName,
        role: job.role,
        type,
        urgency,
        daysLeft,
        message: `${type} for ${job.companyName} is in approximately ${daysLeft} days.`
      });
    }

    // Sort by most urgent
    reminders.sort((a, b) => a.daysLeft - b.daysLeft);

    return {
      totalReminders: reminders.length,
      reminders: reminders.slice(0, 5) // Return top 5 urgent reminders
    };
  }

  async getSalaryNegotiationPrep(userId: string, jobId: string) {
    const job = await this.getJobById(userId, jobId);
    
    // Fallbacks if salary range isn't provided
    const hasSalaryInfo = !!job.salaryRange;
    const baseRole = job.role || "Software Engineer";
    
    let lowEnd = 90000;
    let highEnd = 130000;
    
    // Attempt basic parsing of salary range if it exists
    if (hasSalaryInfo && job.salaryRange) {
      const numbers = job.salaryRange.match(/\d+/g);
      if (numbers && numbers.length >= 2) {
        // e.g. "$110k - $140k" -> [110, 140]
        let num1 = parseInt(numbers[0]);
        let num2 = parseInt(numbers[1]);
        if (num1 < 1000) num1 *= 1000;
        if (num2 < 1000) num2 *= 1000;
        lowEnd = num1;
        highEnd = num2;
      }
    }
    
    const marketAverage = Math.round((lowEnd + highEnd) / 2);
    const targetAsk = Math.round(highEnd * 1.05); // Aim 5% above the top of the range
    
    return {
      jobId,
      company: job.companyName,
      role: job.role,
      hasSalaryInfo,
      marketAverage: `$${marketAverage.toLocaleString()}`,
      recommendedTargetAsk: `$${targetAsk.toLocaleString()}`,
      negotiationTips: [
        "Express excitement about the role before mentioning compensation.",
        `Anchor high but within reason. We recommend starting your ask around $${targetAsk.toLocaleString()}.`,
        "If base salary is rigid, pivot to asking for a sign-on bonus or extra equity.",
        "Highlight your specific past achievements that justify being at the top of their band."
      ]
    };
  }

  async getInterviewPrepChecklist(userId: string, jobId: string) {
    const job = await this.getJobById(userId, jobId);
    
    // We base the checklist on the role
    const roleLower = (job.role || "").toLowerCase();
    
    let technicalTasks = [
      "Review the core technologies listed in the job description",
      "Prepare a 2-minute 'Tell me about yourself' pitch",
      "Research the company's recent news or product launches"
    ];

    if (roleLower.includes("engineer") || roleLower.includes("developer")) {
      technicalTasks = [
        ...technicalTasks,
        "Practice 2-3 LeetCode medium questions",
        "Review system design basics (Load balancers, Caching, Databases)",
        "Prepare questions about their tech stack and deployment process"
      ];
    } else if (roleLower.includes("manager") || roleLower.includes("lead")) {
      technicalTasks = [
        ...technicalTasks,
        "Prepare examples of how you resolve team conflicts",
        "Review project management methodologies you've used",
        "Formulate questions about team structure and current challenges"
      ];
    }

    return {
      jobId,
      company: job.companyName,
      role: job.role,
      checklist: [
        { category: "Research", tasks: [
          "Read the company's 'About Us' and 'Mission' pages",
          "Check the interviewer's LinkedIn profile (if known)",
          "Understand the company's main product/service and target audience"
        ]},
        { category: "Role-Specific Prep", tasks: technicalTasks },
        { category: "Logistics", tasks: [
          "Ensure your background is clean and well-lit (if virtual)",
          "Test your microphone and camera (if virtual)",
          "Have a notebook and pen ready",
          "Have your resume open for reference"
        ]}
      ]
    };
  }

  async estimateCommuteTime(userId: string, id: string) {
    const job = await this.getJobById(userId, id);
    
    if (!job.location || job.location.toLowerCase().includes('remote')) {
      return {
        jobId: id,
        company: job.companyName,
        location: job.location || "Unknown",
        isRemote: true,
        estimatedCommuteMinutes: 0,
        message: "This appears to be a remote role. No commute necessary!"
      };
    }

    // Mock commute calculation
    const distanceMiles = Math.floor(Math.random() * 20) + 5; // 5 to 25 miles
    const estimatedMinutes = Math.floor(distanceMiles * 1.5) + Math.floor(Math.random() * 15); // Rough calc + traffic variance
    
    let mode = "Driving";
    if (job.location.toLowerCase().includes('new york') || job.location.toLowerCase().includes('london')) {
      mode = "Public Transit";
    }

    return {
      jobId: id,
      company: job.companyName,
      location: job.location,
      isRemote: false,
      estimatedDistanceMiles: distanceMiles,
      estimatedCommuteMinutes: estimatedMinutes,
      primaryMode: mode,
      message: `Estimated commute is ${estimatedMinutes} minutes each way via ${mode}.`
    };
  }

  async runAutoArchiving(userId: string) {
    const fortyFiveDaysAgo = new Date();
    fortyFiveDaysAgo.setDate(fortyFiveDaysAgo.getDate() - 45);

    const staleJobs = await prisma.jobApplication.findMany({
      where: {
        userId,
        status: "APPLIED",
        updatedAt: { lte: fortyFiveDaysAgo }
      },
      select: { id: true, notes: true }
    });

    if (staleJobs.length === 0) {
      return {
        archivedCount: 0,
        message: "No stale job applications found to auto-archive."
      };
    }

    const archivedNotePrefix = `[AUTO-ARCHIVED on ${new Date().toISOString()}] No update for 45+ days.\n`;

    // Bulk update requires individual notes to be preserved but we can't easily append per row in Prisma updateMany
    // We'll iterate to preserve existing notes securely
    let archivedCount = 0;
    for (const job of staleJobs) {
      const newNote = archivedNotePrefix + (job.notes || '');
      await prisma.jobApplication.update({
        where: { id: job.id },
        data: { 
          status: "WITHDRAWN",
          notes: newNote
        }
      });
      archivedCount++;
    }

    return {
      archivedCount,
      message: `Successfully auto-archived ${archivedCount} stale applications.`
    };
  }

  async scheduleInterview(
    userId: string,
    id: string,
    data: { date: string; type: string; interviewer?: string; link?: string }
  ) {
    const job = await this.getJobById(userId, id);

    if (!data.date || !data.type) {
      throw ApiError.badRequest("Interview date and type are required.");
    }

    const interviewDate = new Date(data.date);
    if (isNaN(interviewDate.getTime())) {
      throw ApiError.badRequest("Invalid date format.");
    }

    const formattedDate = interviewDate.toLocaleString();
    let interviewNote = `\n[INTERVIEW SCHEDULED]\nDate: ${formattedDate}\nType: ${data.type}`;
    if (data.interviewer) interviewNote += `\nInterviewer: ${data.interviewer}`;
    if (data.link) interviewNote += `\nLink: ${data.link}`;

    const updatedNotes = (job.notes || "") + "\n" + interviewNote;

    return prisma.jobApplication.update({
      where: { id },
      data: {
        status: "INTERVIEW",
        notes: updatedNotes.trim()
      }
    });
  }

  async submitInterviewFeedback(userId: string, id: string, feedback: { rating: number, notes: string }) {
    const job = await this.getJobById(userId, id);

    if (job.status !== "INTERVIEW" && job.status !== "OFFER" && job.status !== "REJECTED") {
      throw ApiError.badRequest("Can only submit interview feedback for jobs that reached the interview stage.");
    }

    if (!feedback.rating || feedback.rating < 1 || feedback.rating > 5) {
      throw ApiError.badRequest("Please provide a valid rating between 1 and 5.");
    }

    if (!feedback.notes || feedback.notes.trim().length === 0) {
      throw ApiError.badRequest("Feedback notes are required.");
    }

    const feedbackEntry = `\n[INTERVIEW FEEDBACK - Rating: ${feedback.rating}/5]\nDate: ${new Date().toLocaleDateString()}\nNotes: ${feedback.notes}`;
    const updatedNotes = (job.notes || "") + "\n" + feedbackEntry;

    return prisma.jobApplication.update({
      where: { id },
      data: {
        notes: updatedNotes.trim()
      }
    });
  }

  async addJobContact(userId: string, id: string, contactData: { name: string, email: string, role: string, linkedin?: string }) {
    const job = await this.getJobById(userId, id);

    if (!contactData.name || !contactData.role) {
      throw ApiError.badRequest("Contact name and role are required");
    }

    // Since we don't have a separate Contacts table, we will append it to notes securely
    const contactInfo = `\n[CONTACT ADDED]\nName: ${contactData.name}\nRole: ${contactData.role}\nEmail: ${contactData.email || 'N/A'}\nLinkedIn: ${contactData.linkedin || 'N/A'}`;
    const updatedNotes = (job.notes || "") + "\n" + contactInfo;

    return prisma.jobApplication.update({
      where: { id },
      data: {
        notes: updatedNotes.trim()
      }
    });
  }
}
