# ===== BUILD =====
FROM node:lts-alpine3.23 AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ===== RUNTIME =====
FROM node:lts-alpine3.23 AS runner
WORKDIR /app

# copia apenas o necessário
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# instala SOMENTE dependências de runtime
RUN npm ci --omit=dev --ignore-scripts

CMD ["node", "dist/main.js"]