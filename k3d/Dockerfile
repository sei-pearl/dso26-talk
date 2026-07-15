ARG K3S_VERSION="v1.36.2-k3s1"
FROM rancher/k3s:${K3S_VERSION} AS k3s

COPY k3s-airgap-images-arm64.tar.zst /var/lib/rancher/k3s/agent/images/

VOLUME /var/lib/kubelet
VOLUME /var/lib/rancher/k3s
VOLUME /var/lib/cni
VOLUME /var/log

ENV INSTALL_K3S_SKIP_DOWNLOAD=true

ENTRYPOINT ["/bin/k3s"]
CMD ["agent"]

