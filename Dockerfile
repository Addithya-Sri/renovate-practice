FROM library/alpine:3.21

RUN mkdir -p /etc/sftp/

COPY --chmod=0600 src/sshd_config /etc/ssh/sshd_config
COPY --chmod=0700 src/bin/* /usr/local/bin/

# Renovate managed dependency pinning
# Packages are looked up directly in the Alpine v3.21 APKINDEX (main + community).
# When the base image moves to a new Alpine release, update branch=v3.21 below.
# renovate: datasource=apk depName=catatonit registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.21&components=main,community&arch=x86_64
ENV CATATONIT_VERSION="0.2.0-r0"
# renovate: datasource=apk depName=bash registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.21&components=main,community&arch=x86_64
ENV BASH_VERSION="5.2.37-r0"
# renovate: datasource=apk depName=shadow registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.21&components=main,community&arch=x86_64
ENV SHADOW_VERSION="4.16.0-r1"
# renovate: datasource=apk depName=openssh-sftp-server registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.21&components=main,community&arch=x86_64
ENV OPENSSH_VERSION="9.9_p2-r0"
# renovate: datasource=apk depName=inotify-tools registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.21&components=main,community&arch=x86_64
ENV INOTIFY_VERSION="4.23.9.0-r0"

# Steps done in one RUN layer:
# - Install upgrades and new packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apk update && apk upgrade && \
    apk add \
      catatonit=${CATATONIT_VERSION} bash=${BASH_VERSION} shadow=${SHADOW_VERSION} \
      openssh-server-pam=${OPENSSH_VERSION} openssh-sftp-server=${OPENSSH_VERSION} \
      inotify-tools=${INOTIFY_VERSION} \
    && \
    rm -rf /var/cache/apk/* && \
    ln -s /usr/sbin/sshd.pam /usr/sbin/sshd && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

LABEL org.opencontainers.image.title="SFTP"
LABEL org.opencontainers.image.description="An Alpine OpenSSH-based SFTP server image"
LABEL org.opencontainers.image.vendor="1&1 MaM - Business Solutions"
LABEL org.opencontainers.image.authors="Arthur Pacaud <arthur.pacaud@1und1.de>"
LABEL org.opencontainers.image.version=${OPENSSH_VERSION}
LABEL org.opencontainers.image.source="https://git.mam.dev/bso/services/sftp/"

EXPOSE 22
VOLUME /etc/ssh/ssh_host_keys/ /etc/sftp/users/ /home/

ENTRYPOINT ["catatonit", "--", "/usr/local/bin/entrypoint"]