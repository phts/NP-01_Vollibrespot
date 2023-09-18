#/usr/bin/env bash

if [[ -z "$CLIENT_ID" ]]; then
  echo "CLIENT_ID env variable is required."
  exit 1
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="${SCRIPT_DIR}/.."

rm -rf "${PROJECT_DIR}/target"

docker run --rm -v "${PROJECT_DIR}":/app -e CLIENT_ID vollibrespot-build
