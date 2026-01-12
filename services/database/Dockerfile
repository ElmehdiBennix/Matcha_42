FROM postgres:16.6-alpine3.21

LABEL maintainer="your-team@example.com"

# Force update packages during build to get latest patches
# Only do this if you need a patch that isn't in the base image yet.
# RUN apk update && apk upgrade --no-cache

# 4. Set the locale (Alpine is minimal, so be explicit)
ENV LANG=en_US.utf8

# 5. Production Performance Tuning (Optional)
# Postgres default config is for low-memory dev machines.
# You can COPY a custom config file optimized for your server size.
# COPY postgresql.conf /etc/postgresql/postgresql.conf
# CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
