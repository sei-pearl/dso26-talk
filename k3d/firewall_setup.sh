#!/usr/bin/env bash

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

