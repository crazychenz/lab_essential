#!/bin/sh

DOCKER_IMG_DIR=/opt/imports/essential_pkgs/docker/

# TODO: Are some of these never customized?

# Import all of the upstream docker images
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Falpine%3Alatest.dockerimage
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Fcaddy%3Aalpine.dockerimage
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Fgitea%3Alatest.dockerimage
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Fact_runner%3Alatest.dockerimage
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Fvaultwarden%3Alatest.dockerimage
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Fnode%3Alts-alpine.dockerimage
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Fpostgres%3A14.dockerimage
docker load < ${DOCKER_IMG_DIR}git.lab.lan%2Fdockerhub%2Fbitnami_openldap%3Alatest.dockerimage

# Build baseline docker images.
docker compose up -d essential_pkgs_svc
echo "Waiting 3 seconds for essential package repos to become available."
sleep 3

  docker compose build dnsmasq_svc # builds git.lab.lan/lab/dnsmasq_svc:stage
  docker save \
    -o ${DOCKER_IMG_DIR}git.lab.lan%2Flab%2Fdnsmasq_svc%3Astage.dockerimage \
    git.lab.lan/lab/dnsmasq_svc:stage

  docker compose build caddy_certs_init # builds git.lab.lan/lab/caddy_certs_init:stage
  docker save \
    -o ${DOCKER_IMG_DIR}git.lab.lan%2Flab%2Fcaddy_certs_init%3Astage.dockerimage \
    git.lab.lan/lab/caddy_certs_init:stage

  docker compose build caddy_rproxy # builds git.lab.lan/lab/caddy_rproxy:stage
  docker save \
    -o ${DOCKER_IMG_DIR}git.lab.lan%2Flab%2Fcaddy_rproxy%3Astage.dockerimage \
    git.lab.lan/lab/caddy_rproxy:stage

  docker compose build openldap_svc
  docker save \
    -o ${DOCKER_IMG_DIR}git.lab.lan%2Flab%openldap_svc%3Astage.dockerimage \
    git.lab.lan/lab/openldap_svc:stage

  docker compose build phpldapadmin_svc
  docker save \
    -o ${DOCKER_IMG_DIR}git.lab.lan%2Flab%phpldapadmin_svc%3Astage.dockerimage \
    git.lab.lan/lab/phpldapadmin_svc:stage

  docker compose build gitea_db # builds git.lab.lan/lab/gitea_db:stage
  docker save \
    -o ${DOCKER_IMG_DIR}git.lab.lan%2Flab%2Fgitea_db%3Astage.dockerimage \
    git.lab.lan/lab/gitea_db:stage

  docker compose build gitea_svc # builds git.lab.lan/lab/gitea_svc:stage
  docker save \
    -o ${DOCKER_IMG_DIR}git.lab.lan%2Flab%2Fgitea_svc%3Astage.dockerimage \
    git.lab.lan/lab/gitea_svc:stage

# Take down temp pkg repo host
docker compose down

