#!/bin/sh

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
