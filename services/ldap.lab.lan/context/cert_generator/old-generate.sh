#!/bin/bash -v

#if [ ! -e "ca.key.pem" ]; then
  openssl req \
    -x509 \
    -days 18250 \
    -nodes \
    -newkey rsa:4096 \
    -keyout ca.key.pem \
    -out ca.cert.pem \
    -subj "/CN=rootCA" \
    -extensions v3_ca
    #-extfile <(echo "basicConstraints = CA:TRUE, pathlen:0\nkeyUsage = keyCertSign, cRLSign")
#fi

#if [ ! -e "intermediate.cert.pem" ]; then
  openssl req \
    -nodes \
    -new \
    -newkey rsa:2048 \
    -keyout intermediate.key.pem \
    -out intermediate.csr.pem \
    -subj "/CN=intermediateCA"

  openssl x509 -req \
    -in intermediate.csr.pem \
    -days 18250 \
    -CA ca.cert.pem \
    -CAkey ca.key.pem \
    -CAcreateserial \
    -out intermediate.cert.pem \
    -extfile <(echo "basicConstraints = CA:TRUE\nkeyUsage = keyCertSign, cRLSign")
#fi

#if [ ! -e "lan-lab.cert.pem" ]; then
  openssl req -nodes -new -newkey rsa:2048 -keyout lan-lab.key.pem -out lan-lab.csr.pem -subj "/CN=lab.lan"
  openssl x509 -req \
    -in lan-lab.csr.pem \
    -days 18250 \
    -CA intermediate.cert.pem \
    -CAkey intermediate.key.pem \
    -CAcreateserial \
    -out lan-lab.cert.pem
    -extfile <(printf "subjectAltName=DNS:dns.lab.lan,DNS:ldap.lab.lan,DNS:git.lab.lan,DNS:words.lab.lan,DNS:*.lab.lan")
#fi

#if [ ! -e "lab-lan.cert.pem" ]; then
  cat lan-lab.cert.pem intermediate.cert.pem > lan-lab.cert-chain.pem
#fi

openssl verify -CAfile ca.cert.pem intermediate.cert.pem lan-lab.cert.pem
