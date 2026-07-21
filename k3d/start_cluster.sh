#!/usr/bin/env bash

# Tooling for Air-Gapped K8s: An Overview of Solutions - Demo Materials
# Copyright 2026 Carnegie Mellon University.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# Licensed under an Apache License v2.0-style license, please see license.txt or contact permission@sei.cmu.edu for full terms.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release and unlimited distribution.  Please see Copyright notice for non-US Government use and distribution.
# DM26-0737

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Error: Script only supports Linux." 
    exit 1
fi

trap "exit" INT

# Detect and normalize architecture.
case "$(uname -m)" in
    x86_64|amd64)
        ARCH="amd64"
        ;;
    aarch64|arm64|armv8*|armv9*|arm*)
        ARCH="arm64"
        ;;
    *)
        echo "Error: Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Checking for k3s:airgap image..."
docker image inspect "k3s:airgap" &>/dev/null

if [ $? -eq 1 ]; then
    echo "Docker image doesn't exist, building..."

    if [ ! -f "k3s-airgap-images-$ARCH.tar.zst" ]; then
        echo "Downloading k3s airgap images for CPU arch: $ARCH"
        wget -q --show-progress \
         https://github.com/k3s-io/k3s/releases/download/v1.36.2+k3s1/k3s-airgap-images-$ARCH.tar.zst
    fi
    docker build -t k3s:airgap .
fi

echo "Checking for k3d-jumpbox:latest image..."
docker image inspect "k3d-jumpbox:latest" &>/dev/null

if [ $? -eq 1 ]; then
    pushd ./jumpbox
    echo "Docker image doesn't exist, building..."
    docker build -t k3d-jumpbox:latest --build-arg ARCH=${ARCH} .
    popd
fi

echo "Checking for k3d-airgap docker network..."
docker network ls | grep k3d-airgap &>/dev/null

if [ $? -eq 1 ]; then
    echo "Docker network not found, creating..."
    docker network create k3d-airgap
fi

echo "Modifying firewall for network bridge (SUDO required)..."
echo "Firewall changes will be wiped on reboot"
sudo bash ./firewall_setup.sh k3d-airgap

echo "Creating k3d airgap cluster" 
k3d cluster create --config ./k3d-airgap.yaml

# Create k3d-jumpbox
docker run -d --name k3d-jumpbox --network k3d-airgap k3d-jumpbox:latest > /dev/null
# Copy kubeconfig into jumpbox container and edit the server address
docker exec k3d-jumpbox mkdir /root/.kube
# Get the k3d-k3s-airgap-server-0 IP
ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' k3d-k3s-airgap-server-0)
echo $ip
k3d kubeconfig print k3s-airgap | sed -E "s/^([[:blank:]]*)server.*/\1server: https:\/\/$ip:6443/" | docker exec -i k3d-jumpbox /bin/bash -c "cat > /root/.kube/config"

echo "K3D Cluster created"
echo "K3D Jumpbox container running, access it by running:"
echo "docker exec -it k3d-jumpbox /bin/bash" 
echo "Copy resourecs into it's file system by using:"
echo "docker cp <file> k3d-jumpbox:<path>"
echo "Use host kubectl or use jumpbox kubectl to interact with the cluster"
echo "docker exec k3d-jumpbox kubectl cluster-info"