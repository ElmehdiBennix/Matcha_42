FROM postgres:16.6-alpine3.21

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

RUN apk update && apk upgrade --no-cache

COPY init.sql /docker-entrypoint-initdb.d/

COPY postgresql.conf /etc/postgresql/postgresql.conf

HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB} || exit 1

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
