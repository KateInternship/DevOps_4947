#!/bin/sh

set -e

USER=vagrant
SSH_DIR="/home/${USER}/.ssh"
KEYS_DIR="/vagrant/keys"
AK_FILE="${SSH_DIR}/authorized_keys"


touch "${AK_FILE}"
chmod 600 "${AK_FILE}"
chown "${USER}:${USER}" "${AK_FILE}"

cat "${KEYS_DIR}"/*.pub 2>/dev/null >> "${AK_FILE}"


sort -u -o "${AK_FILE}" "${AK_FILE}"


grep -q '^PasswordAuthentication no' /etc/ssh/sshd_config || \
  printf '\nPasswordAuthentication no\nChallengeResponseAuthentication no\n' >> /etc/ssh/sshd_config

rc-service sshd restart
echo "[install_keys] $(hostname): authorized_keys merged & sshd restarted"
