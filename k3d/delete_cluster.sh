#!/bin/env bash

echo "Removing k3s-airgap k3d cluster"
k3d cluster delete k3s-airgap

echo "Killing and removing k3d-jumpbox container"
docker kill k3d-jumpbox >/dev/null && docker rm k3d-jumpbox >/dev/null

echo "Deleting k3d-airgap docker network"
docker network rm k3d-airgap

echo "Flushing DOCKER-USER rule chain"
sudo iptables -F DOCKER-USER