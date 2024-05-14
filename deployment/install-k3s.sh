#!/bin/sh

ip r s | grep default >/dev/null
if [ "$?" -ne "0" ]; then
  echo "Please set a default route."
  echo "Example: sudo ip r add default via 192.168.1.254"
  exit 1
fi

mkdir -p /var/lib/rancher/k3s/agent/images/
cp /opt/imports/essential_pkgs/github/k3s-io/k3s-airgap-images-amd64.tar.gz /var/lib/rancher/k3s/agent/images/
cp /opt/imports/essential_pkgs/github/k3s-io/k3s /usr/local/bin
/opt/imports/essential_pkgs/github/k3s-io/install_k3s.sh
su -c "chown \$SUDO_USER:root /etc/rancher/k3s/k3s.yaml"

