#!/bin/sh
set -eu

UID=${UID:-10101}
GID=${GID:-10101}

if [ "${1:-}" == "nyx" ]; then
	HAS_CONFIG=0

	for arg in "$@"; do
		case "$arg" in
			-c|--config)
				HAS_CONFIG=1
				break
				;;
		esac
	done
	
	if [ "$HAS_CONFIG" -eq 1]; then
		exec gosu docker-tor "$@"
	else
		exec gosu docker-tor "$@" -c /etc/tor/nyx
	fi
fi

exec gosu docker-tor "$@"
