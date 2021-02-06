# syntax = docker/dockerfile:1.2
FROM ubuntu:18.04 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    # --mount=type=bind,target=/tmp/workdir,source=. \
    # . /tmp/workdir/bin/install-depends-ubuntu.sh
    depends="build-essential asciidoc binutils bzip2 gawk gettext git \
        libncurses5-dev libz-dev patch python3.5 python2.7 unzip \
        zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs \
        git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev \
        texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev \
        autoconf automake libtool autopoint device-tree-compiler \
        g++-multilib antlr3 gperf wget swig rsync"; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
    apt-get -qq update && \
    apt-get -qqy upgrade && \
    apt-get -y install $depends && \
    apt-get -qqy install sudo

RUN useradd -m openwrt && \
    mkdir -p /etc/sudoers.d && \
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt

WORKDIR /home/openwrt
