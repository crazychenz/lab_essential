#!/bin/sh

# kubectl apply -f manifests/dnsmasq.yaml
# kubectl apply -f manifests/caddy-router.yaml
# kubectl apply -f manifests/gitea.yaml

kubectl apply -k manifests/lab-dns/kustomize/base
kubectl apply -k manifests/lab-rproxy/kustomize/base
kubectl apply -k manifests/lab-git/kustomize/base

#kubectl apply -k manifests/lab-words/kustomize/base
#kubectl apply -k manifests/lab-manual/kustomize/base
