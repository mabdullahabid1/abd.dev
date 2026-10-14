# Production image for Coolify (cfy1). Vercel ignores this file.
FROM node:22-bookworm-slim AS build
WORKDIR /app
RUN npm install -g corepack@latest && corepack enable
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
ARG NEXT_PUBLIC_POSTHOG_ID
ARG VERCEL_ENV
ENV NEXT_TELEMETRY_DISABLED=1
RUN pnpm build && pnpm prune --prod

FROM node:22-bookworm-slim
WORKDIR /app
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 PORT=3000
COPY --from=build /app ./
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
