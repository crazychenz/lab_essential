#!/bin/sh

# Disable upstream repos if we're offline
grep "debian.org" /etc/apt/sources.list >/dev/null
if [ $? -eq 0 ]; then
  mv /etc/apt/sources.list /etc/apt/sources.list.disabled
fi

# Create an offline repository
echo "deb [trusted=yes] file:/opt/state/essential/critical_pkgs/debian ./" \
  > /etc/apt/sources.list.d/critical_pkgs.list
apt-get update
# Install relevant packages from the offline repo
apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# Add user to docker group
#/sbin/adduser $USER docker

# Import all of the docker images
docker load < /opt/state/essential/critical_pkgs/docker/alpine_-_latest.dockerimage
docker load < /opt/state/essential/critical_pkgs/docker/caddy_-_alpine.dockerimage
docker load < /opt/state/essential/critical_pkgs/docker/gitea_-_gitea_-_latest.dockerimage
docker load < /opt/state/essential/critical_pkgs/docker/gitea_-_act_runner_-_latest.dockerimage
docker load < /opt/state/essential/critical_pkgs/docker/vaultwarden_-_server_-_latest.dockerimage
docker load < /opt/state/essential/critical_pkgs/docker/node_-_lts-alpine.dockerimage

#docker compose -f build-docker-compose.yml up dnsmasq_svc

# python3 -m http.server -b 0.0.0.0 8000 &
# PHTHON3_HTTPD_PID=$!
# docker build -t dnsmasq_svc --add-host dockerhost:host-gateway - <<EOF
# FROM alpine:latest
# RUN echo http://dockerhost:8000/data/alpine > /etc/apk/repositories
# RUN apk add -U --allow-untrusted dnsmasq
# EOF
# kill $PHTHON3_HTTPD_PID