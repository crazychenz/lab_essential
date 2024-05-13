#!/bin/sh

cat <<COMMENT_EOF >/dev/null
install -m 0777 -d data/docker
docker pull alpine:latest
docker save -o ./data/docker/alpine__latest.dockerimage alpine:latest
docker pull caddy:alpine
docker save -o ./data/docker/caddy__alpine.dockerimage caddy:alpine
docker pull gitea/gitea:latest
docker save -o ./data/docker/gitea_gitea__latest.dockerimage gitea/gitea:latest
docker pull gitea/act_runner:latest
docker save -o ./data/docker/gitea_act_runner__latest.dockerimage gitea/act_runner:latest
docker pull vaultwarden/server:latest
docker save -o ./data/docker/vaultwarden_server__latest.dockerimage vaultwarden/server:latest
docker pull node:lts-alpine
docker save -o ./data/docker/node__lts-alpine.dockerimage node:lts-alpine

docker build -t debian-pkg-fetcher - <<EOF
FROM debian:12-slim

RUN apt-get update
RUN apt-get install -y apt-rdepends dpkg-dev ca-certificates curl
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc

ENV DOCKER_ASC=/etc/apt/keyrings/docker.asc
ENV DOCKER_URL=https://download.docker.com/linux/debian
RUN echo \
  "deb [arch=\$(dpkg --print-architecture) signed-by=\$DOCKER_ASC] \$DOCKER_URL \
   \$(. /etc/os-release && echo "\$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
EOF

install -m 0777 -d data/debian
docker run --rm -i \
  -v $(pwd)/data/debian:/data \
  -w /data \
  debian-pkg-fetcher /bin/sh <<EOF
PACKAGES="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
apt-get download \$(apt-rdepends \${PACKAGES}|grep -v "^ "|grep -v "^debconf-2.0\$")
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
#sudo apt-add-repository "deb [trusted=yes] file:/data ./"
EOF
COMMENT_EOF

install -m 0777 -d data/alpine/x86_64
docker run -i --rm \
  -v $(pwd)/data/alpine/x86_64:/data \
  -w /data \
  alpine:latest /bin/sh <<EOF
apk update
apk fetch -R dnsmasq
apk index --rewrite-arch x86_64 -o APKINDEX.tar.gz *.apk
EOF

