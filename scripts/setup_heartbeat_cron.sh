#!/bin/sh

set -e

SRC_SCRIPT="/vagrant/scripts/heartbeat.sh"
DST_SCRIPT="/usr/local/bin/heartbeat.sh"

install -m 755 "${SRC_SCRIPT}" "${DST_SCRIPT}"

sed -i '/heartbeat.sh/d' /etc/crontabs/root

cat << 'EOF' >> /etc/crontabs/root
# Heartbeat: кожні 5 хвилин
*/5 * * * * /usr/local/bin/heartbeat.sh
EOF

rc-service crond restart
