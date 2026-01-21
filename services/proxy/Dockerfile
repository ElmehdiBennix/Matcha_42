FROM nginx:1.28-alpine3.23

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

# Copy custom Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf
