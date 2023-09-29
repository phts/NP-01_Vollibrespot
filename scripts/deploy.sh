#/usr/bin/env bash

if [[ -z "$SUDOPASS" ]]; then
  echo "SUDOPASS env variable is required."
  exit 1
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="${SCRIPT_DIR}/.."

echo "Back up..."
mkdir -p "${PROJECT_DIR}/bak"
scp volumio:/usr/bin/vollibrespot "${PROJECT_DIR}/bak/vollibrespot-$(date)"

echo "Uploading..."
scp "${PROJECT_DIR}/target/armv7-unknown-linux-gnueabihf/release/vollibrespot" volumio:/home/volumio/vollibrespot

ssh volumio <<EOF
  set -ex
  echo ${SUDOPASS} | sudo -S killall vollibrespot
  echo ${SUDOPASS} | sudo -S cp /home/volumio/vollibrespot /usr/bin/vollibrespot
  rm -f /home/volumio/vollibrespot
EOF

for arg in "$@"; do
  if [ "$arg" == "--restart" ]; then
    ssh volumio 'sudo systemctl restart volumio'
    echo "Restarting..."
  fi
done
