
FROM library/alpine:3.24

# Renovate managed Alpine APK dependencies

# renovate: datasource=apk depName=catatonit registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.24&components=main,community&arch=x86_64
ENV CATATONIT_VERSION="0.2.0-r0"

# renovate: datasource=apk depName=bash registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.24&components=main,community&arch=x86_64
ENV BASH_VERSION="5.2.37-r0"

# renovate: datasource=apk depName=shadow registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.24&components=main,community&arch=x86_64
ENV SHADOW_VERSION="4.16.0-r1"

# renovate: datasource=apk depName=openssh-sftp-server registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.24&components=main,community&arch=x86_64
ENV OPENSSH_VERSION="10.3_p1-r1"

# renovate: datasource=apk depName=inotify-tools registryUrl=https://dl-cdn.alpinelinux.org/alpine?branch=v3.24&components=main,community&arch=x86_64
ENV INOTIFY_VERSION="4.23.9.0-r0"

RUN apk add --no-cache \
    catatonit=${CATATONIT_VERSION} \
    bash=${BASH_VERSION} \
    shadow=${SHADOW_VERSION} \
    openssh-sftp-server=${OPENSSH_VERSION} \
    inotify-tools=${INOTIFY_VERSION}
