#!/usr/bin/env bash

# Tooling for Air-Gapped K8s: An Overview of Solutions - Demo Materials
# Copyright 2026 Carnegie Mellon University.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# Licensed under an Apache License v2.0-style license, please see license.txt or contact permission@sei.cmu.edu for full terms.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release and unlimited distribution.  Please see Copyright notice for non-US Government use and distribution.
# DM26-0737


set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <docker-network>"
    exit 1
fi

NETWORK="$1"

docker network inspect "$NETWORK" >/dev/null

BRIDGE=$(docker network inspect \
    -f '{{ index .Options "com.docker.network.bridge.name" }}' \
    "$NETWORK")

if [[ -z "$BRIDGE" ]]; then
    NETID=$(docker network inspect -f '{{ .Id }}' "$NETWORK")
    BRIDGE="br-${NETID:0:12}"
fi

RULE="DOCKER-USER -i ${BRIDGE} -o enp0s5 -j DROP"

if iptables -C ${RULE} 2>/dev/null; then
	echo "${BRIDGE} rule already exists."
else
	iptables -A ${RULE}
	echo "${BRIDGE} rule created."
fi

