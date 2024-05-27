#!/bin/sh

DOCKER_IMG_DIR=/opt/imports/essential_pkgs/docker/

# Start webservice with offline repositories
docker compose up -d essential_pkgs_svc
sleep 2

# Build and push runner
docker compose build gitea_sys_runner
docker compose push gitea_sys_runner

docker compose down
