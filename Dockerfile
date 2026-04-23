
## https://hub.docker.com/_/alpine/tags
FROM alpine:3.23.4

## https://pkgs.alpinelinux.org/packages?name=chrony&branch=v3.23&repo=&arch=x86_64&origin=&flagged=&maintainer=
ENV chronyV="chrony=~4.8-r2"

LABEL org.opencontainers.image.authors="rardcode <sak37564@ik.me>"
LABEL Description="Chrony server based on Alpine."

ENV APP_NAME="chrony"

RUN set -xe && \
  : "---------- ESSENTIAL packages INSTALLATION ----------" && \
  apk update --no-cache && \
  apk upgrade --available && \
  apk add bash

RUN set -xe && \
  : "---------- SPECIFIC packages INSTALLATION ----------" && \
  apk update --no-cache && \
  apk add --upgrade ${chronyV}

ADD rootfs /

# Check Process Within The Container Is Healthy
HEALTHCHECK --interval=60s --timeout=5s CMD chronyc tracking > /dev/null

ENTRYPOINT ["/entrypoint.sh"]
CMD ["chronyd", "-d", "-s"]
