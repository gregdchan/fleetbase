#!/bin/sh
# Write the console's runtime config from the environment.
#
# The Ember app fetches /fleetbase.config.json on boot (see nginx.conf, which
# serves it no-cache), so the API host is a RUNTIME value. Without this the
# built image carries whatever fleetbase.config.json was present at build time
# — localhost:8000 — and the same image cannot serve two environments.
#
# Docker Compose sidesteps this by bind-mounting the file. Railway has no bind
# mount, so the file is generated here instead.
set -e

cat > /usr/share/nginx/html/fleetbase.config.json <<JSON
{
  "API_HOST": "${API_HOST:-http://localhost:8000}",
  "SOCKETCLUSTER_HOST": "${SOCKETCLUSTER_HOST:-localhost}",
  "SOCKETCLUSTER_PORT": "${SOCKETCLUSTER_PORT:-38000}",
  "SOCKETCLUSTER_SECURE": "${SOCKETCLUSTER_SECURE:-false}"
}
JSON

exec "$@"
