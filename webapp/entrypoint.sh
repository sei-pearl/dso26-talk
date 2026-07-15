#!/usr/bin/env sh

set -e

echo "Waiting for PostgreSQL..."

until uv run python manage.py check --database default >/dev/null 2>&1
do
    sleep 2
done

echo "Running migrations..."
uv run python manage.py migrate --noinput

echo "Starting Djano Server"

exec uv run manage.py runserver 0.0.0.0:8080