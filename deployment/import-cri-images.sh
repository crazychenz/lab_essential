#!/bin/sh

DOCKER_IMG_DIR=/opt/imports/essential_pkgs/docker/

# Essential Images
until k3s ctr images import ${DOCKER_IMG_DIR}alpine_-_latest.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}git.lab_-_lab_-_dnsmasq_-_initial.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_certs_init_-_initial.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_-_initial.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}git.lab_-_lab_-_gitea_-_latest.dockerimage; do sleep 1; done;

#until k3s ctr images import ${DOCKER_IMG_DIR}caddy_-_alpine.dockerimage; do sleep 1; done;
#until k3s ctr images import ${DOCKER_IMG_DIR}gitea_-_act_runner_-_latest.dockerimage; do sleep 1; done;
#until k3s ctr images import ${DOCKER_IMG_DIR}vaultwarden_-_server_-_latest.dockerimage; do sleep 1; done;
#until k3s ctr images import ${DOCKER_IMG_DIR}node_-_lts-alpine.dockerimage; do sleep 1; done;

# Flux Images
until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_notification-controller.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_kustomize-controller.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_helm-controller.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_source-controller.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_image-automation-controller.dockerimage; do sleep 1; done;

until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_image-reflector-controller.dockerimage; do sleep 1; done;

