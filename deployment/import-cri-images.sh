#!/bin/sh

DOCKER_IMG_DIR=/opt/imports/essential_pkgs/docker/

# Essential Images

until k3s ctr images import ${DOCKER_IMG_DIR}git.lab%2Flab%2Fdnsmasq_svc%3Astage.dockerimage; do sleep 1; done;
until k3s ctr images import ${DOCKER_IMG_DIR}git.lab%2Flab%2Fcaddy_certs_init%3Astage.dockerimage; do sleep 1; done;
until k3s ctr images import ${DOCKER_IMG_DIR}git.lab%2Flab%2Fcaddy_rproxy%3Astage.dockerimage; do sleep 1; done;
until k3s ctr images import ${DOCKER_IMG_DIR}git.lab%2Flab%2Fgitea_db%3Astage.dockerimage; do sleep 1; done;
until k3s ctr images import ${DOCKER_IMG_DIR}git.lab%2Flab%2Fgitea_svc%3Astage.dockerimage; do sleep 1; done;

# Flux Images
# until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_notification-controller.dockerimage; do sleep 1; done;
# until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_kustomize-controller.dockerimage; do sleep 1; done;
# until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_helm-controller.dockerimage; do sleep 1; done;
# until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_source-controller.dockerimage; do sleep 1; done;
# until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_image-automation-controller.dockerimage; do sleep 1; done;
# until k3s ctr images import ${DOCKER_IMG_DIR}ghcr.io_-_fluxcd_-_image-reflector-controller.dockerimage; do sleep 1; done;

