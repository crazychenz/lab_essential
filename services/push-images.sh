#!/bin/sh

# Out custom images
docker push git.lab.lan/lab/caddy_rproxy:stage
docker push git.lab.lan/lab/caddy_certs_init:stage
docker push git.lab.lan/lab/dnsmasq_svc:stage
docker push git.lab.lan/lab/gitea_svc:stage
docker push git.lab.lan/lab/gitea_db:stage

# Upstream images from docker hub
docker push git.lab.lan/dockerhub/alpine:latest
docker push git.lab.lan/dockerhub/caddy:alpine
docker push git.lab.lan/dockerhub/gitea:latest
docker push git.lab.lan/dockerhub/act_runner:latest
docker push git.lab.lan/dockerhub/vaultwarden:latest
docker push git.lab.lan/dockerhub/node:lts-alpine
docker push git.lab.lan/dockerhub/postgres:14

# Upstream images from ghcr.io
docker push git.lab.lan/ghcr.io/fluxcd-notification-controller:v1.3.0
docker push git.lab.lan/ghcr.io/fluxcd-kustomize-controller:v1.3.0
docker push git.lab.lan/ghcr.io/fluxcd-helm-controller:v1.0.1
docker push git.lab.lan/ghcr.io/fluxcd-source-controller:v1.3.0
docker push git.lab.lan/ghcr.io/fluxcd-image-automation-controller:v0.38.0
docker push git.lab.lan/ghcr.io/fluxcd-image-reflector-controller:v0.32.0





