#!/bin/sh

#install -m 0777 -d /opt/state/essential/
#tar -C /opt/state/essential -xf critical_pkgs.tar

DOCKER_IMG_DIR=/opt/imports/essential_pkgs/docker/

# Import all of the docker images
docker load < ${DOCKER_IMG_DIR}alpine_-_latest.dockerimage
docker load < ${DOCKER_IMG_DIR}caddy_-_alpine.dockerimage
#docker load < ${DOCKER_IMG_DIR}gitea_-_gitea_-_latest.dockerimage
#docker load < ${DOCKER_IMG_DIR}gitea_-_act_runner_-_latest.dockerimage
#docker load < ${DOCKER_IMG_DIR}vaultwarden_-_server_-_latest.dockerimage
#docker load < ${DOCKER_IMG_DIR}node_-_lts-alpine.dockerimage

docker compose up -d essential_pkgs_svc
sleep 2
docker compose build dnsmasq_svc
docker save -o ${DOCKER_IMG_DIR}git.lab_-_lab_-_dnsmasq_-_initial.dockerimage git.lab/lab/dnsmasq:initial
docker compose build caddy_certs_init
docker save -o ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_-_certs_init.dockerimage git.lab/lab/caddy:certs_init
docker compose build caddy_router_svc
docker save -o ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_-_initial.dockerimage git.lab/lab/caddy:initial
docker compose down


#  --exclude ./essential_pkgs/alpine \
#  --exclude ./essential_pkgs/debian \


#TARFLAG="-J" # xz compression
TARFLAG="" # no compression
cd /opt/imports
cat >essential_pkgs_install.sh <<SH_EOF
#!/bin/sh
sudo install -m 0777 -d /opt/imports/
sudo install -m 0777 -d /opt/state/
cd /opt/imports/

base64 -d <<TAR_EOF | tar $TARFLAG -xf -
SH_EOF

tar -C /opt/imports \
  --exclude ./essential_pkgs/lab_essential \
  $TARFLAG -cf - essential_pkgs \
  | base64 -w 72 >>essential_pkgs_install.sh

cat >>essential_pkgs_install.sh <<SH_EOF
TAR_EOF

cd essential_pkgs
git clone lab_essential.bundle
SH_EOF

chmod +x essential_pkgs_install.sh







# python3 -m http.server -b 0.0.0.0 8000 &
# PHTHON3_HTTPD_PID=$!
# docker build -t dnsmasq_svc --add-host dockerhost:host-gateway - <<EOF
# FROM alpine:latest
# RUN echo http://dockerhost:8000/data/alpine > /etc/apk/repositories
# RUN apk add -U --allow-untrusted dnsmasq
# EOF
# kill $PHTHON3_HTTPD_PID