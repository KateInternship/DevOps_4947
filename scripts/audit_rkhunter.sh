#!/bin/sh

set -e

apk add --no-cache perl wget tar coreutils grep openssl >/dev/null

cd /tmp
[ -d rkhunter-1.4.6 ] || wget -q \
  https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.6/rkhunter-1.4.6.tar.gz
tar zxf rkhunter-1.4.6.tar.gz --skip-old-files

cd rkhunter-1.4.6
./installer.sh --layout default --install >/dev/null 2>&1 || true

LOG=/var/log/rkhunter.log
rkhunter --update            >>"$LOG" 2>&1 || true
rkhunter --propupd           >>"$LOG" 2>&1 || true
yes | rkhunter --check       >>"$LOG" 2>&1 || true

echo "[audit] $(hostname): rkhunter done → $LOG"
exit 0
