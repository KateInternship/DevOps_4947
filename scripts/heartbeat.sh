#!/bin/sh

set -eu

USER=vagrant
SSH_KEY="/home/${USER}/.ssh/id_ed25519"

ME=$(hostname)
TIME=$(date +'%F_%T')
TMPFILE="/tmp/${ME}_${TIME}.heartbeat"
REMOTE_DIR="incoming"

echo "${ME} ${TIME}" > "${TMPFILE}"

for IP in 192.168.198.2 192.168.198.3 192.168.198.4; do
  [ "$(hostname -i)" = "$IP" ] && continue

  printf "[%s] Sending to %s…\n" "$ME" "$IP"
  sudo -u "${USER}" sftp -q -i "${SSH_KEY}" \
    -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no \
    "${USER}@${IP}:${REMOTE_DIR}/" <<EOF || true
put ${TMPFILE}
EOF
done

rm -f "${TMPFILE}"
