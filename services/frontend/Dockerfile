################################################
# BUILD ARGUMENTS
################################################
ARG NODE_BASE=node:24-alpine3.23

################################################
# Base Stage
################################################
FROM ${NODE_BASE} AS base

ENV CI=TRUE
ENV NPM_CONFIG_LOGLEVEL=warn

WORKDIR /app

RUN apk add --no-cache postgresql-client bash libc6-compat && \
    corepack enable && corepack prepare pnpm@latest --activate

################################################
# Dependencies Stage
################################################
FROM base AS dependencies

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

################################################
# Development Stage
################################################
FROM base AS development

ENV NODE_ENV=development

COPY --from=dependencies /app/node_modules ./node_modules

EXPOSE 3000

ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "sh", "-c" , "while true; do pnpm run dev; echo 'Server died restarting...'; sleep 1; done" ]

################################################
# Build Stage
################################################
FROM base AS build

COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

RUN pnpm run build

RUN pnpm prune --prod

################################################
# Production Stage
################################################
FROM ${NODE_BASE} AS production

ARG TITLE="Matcha"
ARG DESCRIPTION="A 42 Project dating application"
ARG BUILD_DATE="unknown"
ARG VERSION="latest"
ARG REVISION="unknown"
ARG SOURCE="domain"

LABEL org.opencontainers.image.title=${TITLE} \
    org.opencontainers.image.description=${DESCRIPTION} \
    org.opencontainers.image.source=${SOURCE} \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.version=${VERSION} \
    org.opencontainers.image.authors=${AUTHOR}

WORKDIR /app

ENV NODE_ENV=production

RUN addgroup -S matchaGroup && adduser -S matcha -G matchaGroup

COPY --from=build --chown=matcha:matchaGroup /app/package.json ./package.json
COPY --from=build --chown=matcha:matchaGroup /app/node_modules ./node_modules
COPY --from=build --chown=matcha:matchaGroup /app/dist ./dist

USER matcha

EXPOSE 3000

# HEALTHCHECK --interval=30s --timeout=3s \
#   CMD http://localhost:3000/health || exit 1

ENTRYPOINT [ "" ]
CMD [ "" ]
