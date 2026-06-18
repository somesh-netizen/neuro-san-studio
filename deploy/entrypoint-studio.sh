#!/bin/bash
# All-in-one entrypoint for neuro-san-studio.
# Starts BOTH the neuro-san agent server (internal, port 8080) and the
# nsflow web UI (public). nsflow's backend proxies to the server over localhost,
# so only the UI port needs to be exposed by the platform (e.g. Cloud Run).
set -euo pipefail

# Cloud Run (and similar) route external traffic to $PORT. The nsflow UI must
# listen there. The agent server stays internal on 8080; nsflow reaches it on
# localhost. We default to 4173 for local/other runs.
export NSFLOW_HOST="0.0.0.0"
export NSFLOW_PORT="${PORT:-4173}"
export NEURO_SAN_SERVER_HOST="localhost"
export NEURO_SAN_SERVER_HTTP_PORT="8080"

echo "Starting neuro-san-studio: agent server on :8080 (internal), nsflow UI on :${NSFLOW_PORT} (public)"

# `run` launches the server and the nsflow UI together and stays in the foreground.
exec python3 -m neuro_san_studio run \
  --server-host localhost \
  --server-http-port 8080 \
  --nsflow-host 0.0.0.0 \
  --nsflow-port "${NSFLOW_PORT}"
