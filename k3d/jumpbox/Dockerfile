FROM ubuntu:26.04

ARG ARCH=arm64
ARG ZARF_VERSION=v0.81.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl vim \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*

RUN curl -sfL https://get.hauler.dev | HAULER_INSTALL_DIR=/usr/local/bin bash

RUN curl -sfL "https://github.com/zarf-dev/zarf/releases/download/${ZARF_VERSION}/zarf_${ZARF_VERSION}_Linux_${ARCH}" -o zarf \
    && mv zarf /usr/local/bin/zarf \
    && chmod +x /usr/local/bin/zarf

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
    && mv kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

ENTRYPOINT ["sleep", "infinity"]