#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y curl sqlite3

echo "Downloading PowerDNS .deb..."
curl -O https://downloads.powerdns.com/releases/deb/pdns-static_3.4.7-1_amd64.deb
echo "Installing PowerDNS .deb..."
sudo dpkg -i pdns-static_3.4.7-1_amd64.deb
echo "Deleting PowerDNS .deb..."
rm pdns-static_3.4.7-1_amd64.deb

echo "Creating PowerDNS database..."
sudo mkdir -p /var/lib/powerdns
sqlite3 /var/lib/powerdns/pdns.db < /tmp/powerdns.sql

sudo bash -c 'cat << EOF > /etc/powerdns/pdns.conf
launch=gsqlite3
gsqlite3-database=/var/lib/powerdns/pdns.db

experimental-json-interface=yes
experimental-api-key=changeme

webserver=yes
webserver-address=0.0.0.0
webserver-port=8081
EOF'