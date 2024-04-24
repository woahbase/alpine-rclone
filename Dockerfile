# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG SRCARCH
ARG VERSION
#
RUN set -xe \
    && apk add --no-cache --purge -uU \
        ca-certificates \
        curl \
        fuse3 \
        tzdata \
        unzip \
        zip \
    && echo "user_allow_other" >> /etc/fuse.conf \
    && curl \
        -o /tmp/rclone-v${VERSION}-${SRCARCH}.zip \
        -jSLN https://github.com/rclone/rclone/releases/download/v${VERSION}/rclone-v${VERSION}-${SRCARCH}.zip \
    && curl \
        -o /tmp/SHA256SUMS \
        -jSLN https://github.com/rclone/rclone/releases/download/v${VERSION}/SHA256SUMS \
    && cd /tmp/ \
    && grep rclone-v${VERSION}-${SRCARCH}.zip SHA256SUMS | sha256sum -c \
    && unzip /tmp/rclone-v${VERSION}-${SRCARCH}.zip \
    && mv /tmp/rclone-*-${SRCARCH}/rclone /usr/local/bin/ \
    # && mkdir -p /usr/local/share/man/man1 \
    # && mv /tmp/rclone-*-${SRCARCH}/rclone.1 /usr/local/share/man/man1/ \
    # && mandb \
    && apk del --purge curl \
    && rm -rf /var/cache/apk/* /tmp/*
#
# VOLUME /home/alpine/
# WORKDIR /home/alpine/
#
ENTRYPOINT ["/usershell"]
CMD ["rclone", "--version"]
