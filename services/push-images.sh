#!/bin/sh

# Out custom images
docker push git.lab/lab/caddy_rproxy:stage
docker push git.lab/lab/caddy_certs_init:stage
docker push git.lab/lab/dnsmasq_svc:stage
docker push git.lab/lab/gitea_svc:stage
docker push git.lab/lab/gitea_db:stage

# Upstream images from docker hub
docker push git.lab/dockerhub/alpine:latest
docker push git.lab/dockerhub/caddy:alpine
docker push git.lab/dockerhub/gitea:latest
docker push git.lab/dockerhub/act_runner:latest
docker push git.lab/dockerhub/vaultwarden:latest
docker push git.lab/dockerhub/node:lts-alpine
docker push git.lab/dockerhub/postgres:14

# Upstream images from ghcr.io
docker push git.lab/ghcr.io/fluxcd-notification-controller:v1.3.0
docker push git.lab/ghcr.io/fluxcd-kustomize-controller:v1.3.0
docker push git.lab/ghcr.io/fluxcd-helm-controller:v1.0.1
docker push git.lab/ghcr.io/fluxcd-source-controller:v1.3.0
docker push git.lab/ghcr.io/fluxcd-image-automation-controller:v0.38.0
docker push git.lab/ghcr.io/fluxcd-image-reflector-controller:v0.32.0





