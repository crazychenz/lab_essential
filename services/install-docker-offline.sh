#!/bin/sh

# Disable upstream repos if we're offline
grep "debian.org" /etc/apt/sources.list >/dev/null
if [ $? -eq 0 ]; then
  mv /etc/apt/sources.list /etc/apt/sources.list.disabled
fi

# Create an offline repository
echo "deb [trusted=yes] file:/opt/imports/essential_pkgs/debian ./" \
  > /etc/apt/sources.list.d/essential_pkgs.list
apt-get update
# Install relevant packages from the offline repo
apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# Add user to docker group
/sbin/adduser $SUDO_USER docker

# Revert changes
mv /etc/apt/sources.list.disabled /etc/apt/sources.list
rm -f /etc/apt/sources.list.d/essential_pkgs.list
apt-get update