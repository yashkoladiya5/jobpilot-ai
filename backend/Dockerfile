FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json ./

RUN npm install

COPY src ./src
COPY prisma ./prisma
COPY tsconfig.json ./

RUN npx prisma generate
RUN npm run build

FROM node:18-alpine AS production

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

EXPOSE 3000

CMD ["node", "dist/index.js"]
