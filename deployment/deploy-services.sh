#!/bin/sh

kubectl apply -f manifests/dnsmasq.yaml
kubectl apply -f manifests/caddy_router.yaml
kubectl apply -f manifests/gitea.yaml
