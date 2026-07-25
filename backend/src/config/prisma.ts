import { PrismaClient } from '@prisma/client';

// Initialize the Prisma Client for database interaction.
// Query logging is enabled only in the development environment for easier debugging.
const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

export default prisma;
