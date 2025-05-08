#!/bin/sh

set -e

USER=vagrant
SSH_DIR="/home/${USER}/.ssh"
PRIV_KEY="${SSH_DIR}/id_ed25519"
PUB_KEY="${PRIV_KEY}.pub"
KEYS_DIR="/vagrant/keys"

mkdir -p "${SSH_DIR}" "${KEYS_DIR}"
chmod 700 "${SSH_DIR}"
chown "${USER}:${USER}" "${SSH_DIR}"

if [ ! -f "${PRIV_KEY}" ]; then
  su - "${USER}" -c "ssh-keygen -t ed25519 -N '' -f ${PRIV_KEY}"
fi

cp -f "${PUB_KEY}" "${KEYS_DIR}/$(hostname).pub"
echo "[gen_keys] $(hostname): key generated & exported"
