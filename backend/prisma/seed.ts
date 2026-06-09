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
