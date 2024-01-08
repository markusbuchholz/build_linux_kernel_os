FROM ubuntu:20.04


RUN apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    git \
    vim \
    nano \
    make \
    gcc \
    libncurses-dev \
    flex \
    bison \
    bc \
    cpio \
    libelf-dev \
    libssl-dev \
    syslinux \
    dosfstools \
    ca-certificates && \
    update-ca-certificates


RUN git clone --depth 1 https://github.com/torvalds/linux.git


RUN git clone --depth 1 https://git.busybox.net/busybox


WORKDIR /linux

