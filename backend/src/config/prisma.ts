import { PrismaClient } from '@prisma/client';

/**
 * Shared Prisma Client instance for database interactions.
 * Configured to log queries in development for easier debugging.
 */
const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

export default prisma;
