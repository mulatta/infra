#!/usr/bin/env bash
set -eu

: "${PGPORT:=15432}"

# Check if tunnel already exists
if lsof -i ":${PGPORT}" &>/dev/null; then
  echo "Tunnel already running on port ${PGPORT}" >&2
  exit 0
fi

# eta -> rho (10.100.0.3) PostgreSQL tunnel
ssh -f -N -L "${PGPORT}:10.100.0.3:5432" eta

echo "Tunnel established: localhost:${PGPORT} -> rho:5432" >&2
