#!/bin/sh
set -eu

SOCKS_HOST="${TOR_SOCKS_HOST:-127.0.0.1}"
SOCKS_PORT="${TOR_SOCKS_PORT:-9050}"
URL=${HEALTHCHECK_URL:-https://check.torproject.org/api/ip}"

curl -fsS --socks5-hostname "${SOCKS_HOST}:${SOCKS_PORT}" "$URL" >/dev/null
