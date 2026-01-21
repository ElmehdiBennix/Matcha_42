FROM postgres:16.6-alpine3.21

RUN apk update && apk upgrade --no-cache

COPY init.sql /docker-entrypoint-initdb.d/

COPY postgresql.conf /etc/postgresql/postgresql.conf

HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB} || exit 1

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
