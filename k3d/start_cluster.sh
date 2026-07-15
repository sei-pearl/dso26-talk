#!/bin/bash

sudo bash ./firewall_setup.sh k3d
k3d cluster create --config ./k3d-airgap.yaml
