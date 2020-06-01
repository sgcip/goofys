FROM alpine:3.11

MAINTAINER SGCIP ProServ <cip-ps@sgcip.com>

RUN apk update && apk add gcc ca-certificates openssl musl-dev git fuse syslog-ng coreutils curl

ENV GOOFYS_VERSION 0.24.0
ENV CATFS_VERSION 0.8.0

RUN curl --fail -sSL -o /usr/local/bin/goofys https://github.com/kahing/goofys/releases/download/v${GOOFYS_VERSION}/goofys \
    && chmod +x /usr/local/bin/goofys
RUN curl -sSL -o /usr/local/bin/catfs https://github.com/kahing/catfs/releases/download/v${CATFS_VERSION}/catfs && chmod +x /usr/local/bin/catfs

ARG ENDPOINT
ENV MOUNT_DIR /mnt/s3
ENV REGION eu-west-1
ENV BUCKET teleport-bucket
ENV STAT_CACHE_TTL 1m0s
ENV TYPE_CACHE_TTL 1m0s
ENV DIR_MODE 0700
ENV FILE_MODE 0600
ENV UID 0
ENV GID 0

RUN mkdir /mnt/s3

VOLUME /mnt/s3

ADD rootfs/ /

RUN chmod +x /usr/bin/run.sh

ENTRYPOINT ["sh"]
CMD ["/usr/bin/run.sh"]
