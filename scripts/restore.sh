#/usr/bin/env bash

if [[ -z "$SUDOPASS" ]]; then
  echo "SUDOPASS env variable is required."
  exit 1
fi

BACKUP_FILE=$1
if [[ -z "$BACKUP_FILE" ]]; then
  echo "File name is required."
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="${SCRIPT_DIR}/.."

echo "Back up..."
mkdir -p "${PROJECT_DIR}/bak"
scp volumio:/usr/bin/vollibrespot "${PROJECT_DIR}/bak/vollibrespot-$(date -Iseconds)"

echo "Uploading ${BACKUP_FILE}..."
scp "${PROJECT_DIR}/bak/${BACKUP_FILE}" volumio:/home/volumio/vollibrespot

ssh volumio <<EOF
  set -ex
  echo ${SUDOPASS} | sudo -S killall vollibrespot
  echo ${SUDOPASS} | sudo -S cp /home/volumio/vollibrespot /usr/bin/vollibrespot
  rm -f /home/volumio/vollibrespot
  /usr/bin/vollibrespot --version
EOF

for arg in "$@"; do
  if [ "$arg" == "--restart" ]; then
    ssh volumio 'sudo systemctl restart volumio'
    echo "Restarting..."
  fi
done
