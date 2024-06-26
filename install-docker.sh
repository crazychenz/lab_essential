#!/bin/sh

apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg \
  -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

DOCKER_ASC=/etc/apt/keyrings/docker.asc
DOCKER_URL=https://download.docker.com/linux/debian
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=$DOCKER_ASC] $DOCKER_URL \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
  docker-compose-plugin

adduser $USER docker