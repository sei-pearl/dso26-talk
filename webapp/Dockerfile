# Tooling for Air-Gapped K8s: An Overview of Solutions - Demo Materials
# Copyright 2026 Carnegie Mellon University.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# Licensed under an Apache License v2.0-style license, please see license.txt or contact permission@sei.cmu.edu for full terms.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release and unlimited distribution.  Please see Copyright notice for non-US Government use and distribution.
# DM26-0737
FROM ghcr.io/astral-sh/uv:latest AS uv

LABEL org.opencontainers.image.source=https://github.com/sei-pearl/dso26-talk

FROM python:3.14-slim
WORKDIR /app

COPY --from=uv /uv /bin/uv

COPY pyproject.toml uv.lock ./
RUN uv sync --locked

COPY . .

ENTRYPOINT ["bash", "entrypoint.sh"]
