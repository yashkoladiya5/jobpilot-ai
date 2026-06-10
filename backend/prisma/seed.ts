import { PrismaClient, ApplicationStatus } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  const password = await bcrypt.hash('password123', 10);

  const user1 = await prisma.user.upsert({
    where: { email: 'user1@example.com' },
    update: {},
    create: {
      email: 'user1@example.com',
      passwordHash: password,
      name: 'John Doe',
    },
  });

  const user2 = await prisma.user.upsert({
    where: { email: 'user2@example.com' },
    update: {},
    create: {
      email: 'user2@example.com',
      passwordHash: password,
      name: 'Jane Smith',
    },
  });

  const resume1 = await prisma.resume.upsert({
    where: { id: '00000000-0000-0000-0000-000000000001' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000001',
      userId: user1.id,
      fileName: 'john_doe_resume.pdf',
      filePath: '/uploads/resumes/john_doe_resume.pdf',
      fileSize: 245760,
      mimeType: 'application/pdf',
      isPrimary: true,
    },
  });

  const resume2 = await prisma.resume.upsert({
    where: { id: '00000000-0000-0000-0000-000000000002' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000002',
      userId: user2.id,
      fileName: 'jane_smith_resume.pdf',
      filePath: '/uploads/resumes/jane_smith_resume.pdf',
      fileSize: 198400,
      mimeType: 'application/pdf',
      isPrimary: true,
    },
  });

  const applications = [
    {
      userId: user1.id,
      companyName: 'Google',
      role: 'Software Engineer',
      jobUrl: 'https://careers.google.com/jobs/123',
      salaryRange: '$150k - $200k',
      location: 'Mountain View, CA',
      status: ApplicationStatus.INTERVIEW,
      notes: 'Reached onsite interview stage.',
      appliedDate: new Date('2026-05-01'),
    },
    {
      userId: user1.id,
      companyName: 'Stripe',
      role: 'Backend Engineer',
      jobUrl: 'https://stripe.com/jobs/456',
      salaryRange: '$140k - $190k',
      location: 'Remote',
      status: ApplicationStatus.APPLIED,
      notes: 'Waiting for recruiter screen.',
      appliedDate: new Date('2026-05-20'),
    },
    {
      userId: user1.id,
      companyName: 'Airbnb',
      role: 'Full Stack Engineer',
      jobUrl: null,
      salaryRange: null,
      location: 'San Francisco, CA',
      status: ApplicationStatus.SAVED,
      notes: null,
      appliedDate: new Date('2026-06-01'),
    },
    {
      userId: user2.id,
      companyName: 'Meta',
      role: 'Product Designer',
      jobUrl: 'https://metacareers.com/jobs/789',
      salaryRange: '$130k - $180k',
      location: 'New York, NY',
      status: ApplicationStatus.OFFER,
      notes: 'Got an offer! Negotiating terms.',
      appliedDate: new Date('2026-04-15'),
    },
    {
      userId: user2.id,
      companyName: 'Figma',
      role: 'UX Engineer',
      jobUrl: 'https://figma.com/careers/101',
      salaryRange: '$120k - $170k',
      location: 'San Francisco, CA',
      status: ApplicationStatus.REJECTED,
      notes: 'Rejected after final round.',
      appliedDate: new Date('2026-03-10'),
    },
    {
      userId: user2.id,
      companyName: 'Notion',
      role: 'Design Engineer',
      jobUrl: 'https://notion.so/jobs/202',
      salaryRange: '$125k - $175k',
      location: 'Remote',
      status: ApplicationStatus.INTERVIEW,
      notes: 'Technical screen scheduled.',
      appliedDate: new Date('2026-05-25'),
    },
  ];

  for (const app of applications) {
    await prisma.jobApplication.create({ data: app });
  }

  // --- AI Seed Data ---

  // Interview Session for user1
  const interviewSession = await prisma.interviewSession.upsert({
    where: { id: '00000000-0000-0000-0000-000000000010' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000010',
      userId: user1.id,
      jobId: applications[0].id,
      status: 'COMPLETED',
      jobDescription: 'Software Engineer role at Google requiring distributed systems experience.',
      hrQuestions: [
        { question: 'Tell me about yourself.', category: 'HR' },
        { question: 'Why do you want to work at Google?', category: 'HR' },
      ],
      technicalQuestions: [
        { question: 'Explain how a hash map works.', category: 'TECHNICAL' },
        { question: 'Design a rate limiter.', category: 'TECHNICAL' },
      ],
      behavioralQuestions: [
        { question: 'Describe a time you handled a conflict.', category: 'BEHAVIORAL' },
        { question: 'Tell me about a project you led.', category: 'BEHAVIORAL' },
      ],
      followUpQuestions: [],
      currentQuestionIndex: 4,
      totalQuestions: 4,
      answeredQuestions: 4,
      score: 85,
      promptVersion: '1.0',
      completedAt: new Date('2026-06-05'),
    },
  });

  // Interview Questions
  const interviewQuestions = [
    {
      id: '00000000-0000-0000-0000-000000000101',
      sessionId: interviewSession.id,
      category: 'HR',
      question: 'Tell me about yourself.',
      orderIndex: 0,
      answer: 'I am a software engineer with 5 years of experience building distributed systems.',
      feedback: 'Good concise introduction. Could mention specific technologies.',
      score: 8,
      answeredAt: new Date('2026-06-05T10:00:00Z'),
    },
    {
      id: '00000000-0000-0000-0000-000000000102',
      sessionId: interviewSession.id,
      category: 'HR',
      question: 'Why do you want to work at Google?',
      orderIndex: 1,
      answer: 'I admire Google\'s technical excellence and scale of impact.',
      feedback: 'Mention specific products or teams to show research.',
      score: 7,
      answeredAt: new Date('2026-06-05T10:02:00Z'),
    },
    {
      id: '00000000-0000-0000-0000-000000000103',
      sessionId: interviewSession.id,
      category: 'TECHNICAL',
      question: 'Explain how a hash map works.',
      orderIndex: 2,
      answer: 'A hash map uses a hash function to compute an index into an array of buckets.',
      feedback: 'Correct. Could elaborate on collision resolution strategies.',
      score: 9,
      answeredAt: new Date('2026-06-05T10:05:00Z'),
    },
    {
      id: '00000000-0000-0000-0000-000000000104',
      sessionId: interviewSession.id,
      category: 'BEHAVIORAL',
      question: 'Describe a time you handled a conflict.',
      orderIndex: 3,
      answer: 'I mediated a disagreement between team members over architecture choices.',
      feedback: 'Good example. Use STAR format for more impact.',
      score: 8,
      answeredAt: new Date('2026-06-05T10:10:00Z'),
    },
  ];

  for (const q of interviewQuestions) {
    await prisma.interviewQuestion.upsert({
      where: { id: q.id },
      update: {},
      create: q,
    });
  }

  // Interview Result
  await prisma.interviewResult.upsert({
    where: { id: '00000000-0000-0000-0000-000000000201' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000201',
      sessionId: interviewSession.id,
      overallScore: 85,
      categoryScores: { hr: 75, technical: 90, behavioral: 80 },
      strengths: ['Clear communication', 'Strong technical foundation'],
      improvements: ['Use STAR format', 'Be more specific about technologies'],
      summary: 'Strong overall performance with room for improvement in behavioral responses.',
    },
  });

  // Career Insights for user1
  const careerInsight = await prisma.careerInsight.upsert({
    where: { id: '00000000-0000-0000-0000-000000000301' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000301',
      userId: user1.id,
      careerScore: 72,
      interviewReadiness: 68,
      resumeStrength: 75,
      jobMatchQuality: 70,
      applicationSuccessRate: 60,
      skillGaps: ['System Design', 'Kubernetes', 'GraphQL'],
      weeklyProgress: {
        applicationsSubmitted: 3,
        interviews: 1,
        offers: 0,
        rejections: 1,
      },
      recommendations: [
        'Focus on system design interview prep',
        'Add Kubernetes projects to resume',
        'Apply to 2 more positions this week',
      ],
      weekStart: new Date('2026-06-01'),
    },
  });

  // Career Insights for user2
  await prisma.careerInsight.upsert({
    where: { id: '00000000-0000-0000-0000-000000000302' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000302',
      userId: user2.id,
      careerScore: 80,
      interviewReadiness: 85,
      resumeStrength: 78,
      jobMatchQuality: 82,
      applicationSuccessRate: 75,
      skillGaps: ['Prototyping', 'Design Systems'],
      weeklyProgress: {
        applicationsSubmitted: 5,
        interviews: 2,
        offers: 1,
        rejections: 1,
      },
      recommendations: [
        'Build a design system portfolio piece',
        'Practice whiteboarding exercises',
      ],
      weekStart: new Date('2026-06-01'),
    },
  });

  console.log('Seed completed successfully');
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
