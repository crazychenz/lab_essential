#!/bin/sh

DOCKER_IMG_DIR=/opt/imports/essential_pkgs/docker/

k3s ctr images import ${DOCKER_IMG_DIR}alpine_-_latest.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}caddy_-_alpine.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}gitea_-_gitea_-_latest.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}gitea_-_act_runner_-_latest.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}vaultwarden_-_server_-_latest.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}node_-_lts-alpine.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}git.lab_-_lab_-_dnsmasq_-_initial.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_-_certs_init.dockerimage
k3s ctr images import ${DOCKER_IMG_DIR}git.lab_-_lab_-_caddy_-_initial.dockerimage