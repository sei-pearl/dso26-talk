FROM ghcr.io/astral-sh/uv:latest AS uv

LABEL org.opencontainers.image.source=https://github.com/sei-pearl/dso26-talk

FROM python:3.14-slim
WORKDIR /app

COPY --from=uv /uv /bin/uv

COPY pyproject.toml uv.lock ./
RUN uv sync --locked

COPY . .

ENTRYPOINT ["bash", "entrypoint.sh"]
