#!/bin/sh

docker push git.lab/lab/caddy:initial
docker push git.lab/lab/caddy_certs_init:initial
docker push git.lab/lab/dnsmasq:initial
docker push git.lab/lab/gitea:latest

docker push git.lab/lab/caddy:alpine
docker push git.lab/lab/vaultwarden:latest
docker push git.lab/lab/node:lts-alpine

