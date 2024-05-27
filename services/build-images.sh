#!/bin/sh

DOCKER_IMG_DIR=/opt/imports/essential_pkgs/docker/

# Import all of the docker images
docker load < ${DOCKER_IMG_DIR}alpine_-_latest.dockerimage

docker load < ${DOCKER_IMG_DIR}caddy_-_alpine.dockerimage
docker tag caddy:alpine git.lab/lab/caddy:alpine

docker load < ${DOCKER_IMG_DIR}gitea_-_gitea_-_latest.dockerimage
docker tag gitea/gitea:latest git.lab/lab/gitea:latest
docker save -o ${DOCKER_IMG_DIR}git.lab_-_lab_-_gitea_-_latest.dockerimage git.lab/lab/gitea:latest

docker load < ${DOCKER_IMG_DIR}vaultwarden_-_server_-_latest.dockerimage
docker tag vaultwarden/server:latest git.lab/lab/vaultwarden:latest
docker load < ${DOCKER_IMG_DIR}node_-_lts-alpine.dockerimage
docker tag node:lts-alpine git.lab/lab/node:lts-alpine
docker load < ${DOCKER_IMG_DIR}gitea_-_act_runner_-_latest.dockerimage
docker tag gitea/act_runner:latest git.lab/lab/gitea_act_runner:latest

docker compose up -d essential_pkgs_svc
sleep 2
docker compose build dnsmasq_svc
docker save -o ${DOCKER_IMG_DIR}git.lab_-_lab_-_dnsmasq_-_initial.dockerimage git.lab/lab/dnsmasq:initial
docker compose build caddy_certs_init
docker save -o ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_certs_init_-_initial.dockerimage git.lab/lab/caddy_certs_init:initial
docker compose build caddy_router_svc
docker save -o ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_-_initial.dockerimage git.lab/lab/caddy:initial
docker compose down
