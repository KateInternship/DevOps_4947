#!/bin/sh

set -e

SRC="/vagrant/scripts/heartbeat.sh"
DST="/usr/local/bin/heartbeat.sh"

install -m 755 "$SRC" "$DST"

mkdir -p /home/vagrant/incoming
chown vagrant:vagrant /home/vagrant/incoming

mkdir -p /vagrant/csv_logs
chmod 777 /vagrant/csv_logs

sed -i '/heartbeat.sh/d' /etc/crontabs/root
cat << 'EOF' >> /etc/crontabs/root
*/5 * * * * /usr/local/bin/heartbeat.sh
EOF

rc-service crond restart
