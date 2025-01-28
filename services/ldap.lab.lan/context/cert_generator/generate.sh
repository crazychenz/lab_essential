#!/bin/bash


openssl req -newkey rsa:4096 -nodes -keyout lab-root.key -out lab-root.csr -subj "/CN=RootCA"

openssl x509 -req -in lab-root.csr -signkey lab-root.key -out lab-root.crt -days 18250 \
  -extfile <(echo -e "basicConstraints = CA:TRUE\nkeyUsage = keyCertSign, cRLSign")

#openssl req -newkey rsa:2048 -nodes -keyout lab-intermediate.key -out lab-intermediate.csr -subj "/CN=IntermediateCA"

#openssl x509 -req -in lab-intermediate.csr -CA lab-root.crt -CAkey lab-root.key -CAcreateserial -out lab-intermediate.crt -days 18250 \
#  -extfile <(echo -e "basicConstraints = CA:TRUE, pathlen:0\nkeyUsage = keyCertSign, cRLSign")

#openssl req -newkey rsa:2048 -nodes -keyout lab-apps.key -out lab-apps.csr -subj "/CN=lab"

#openssl x509 -req -in lab-apps.csr -CA lab-intermediate.crt -CAkey lab-intermediate.key -CAcreateserial -out lab-apps.crt -days 18250 \
#  -extfile <(printf "subjectAltName=DNS:dns.lab.lan,DNS:ldap.lab.lan,DNS:git.lab.lan,DNS:words.lab.lan,DNS:*.lab.lan")

#cat lab-intermediate.crt lab-root.crt > lab-root.chain.crt
#cat lab-apps.crt lab-intermediate.crt lab-root.crt > lab-apps.chain.crt

#openssl verify -CAfile lab-root.crt lab-apps.chain.crt

#openssl verify -CAfile lab-root.crt -untrusted lab-intermediate.crt lab-apps.chain.crt

openssl req -newkey rsa:2048 -nodes -keyout lab.lan.key -out lab.lan.csr -subj "/CN=lab"

openssl x509 -req -in lab.lan.csr -CA lab-root.crt -CAkey lab-root.key -CAcreateserial -out lab.lan.crt -days 18250 \
  -extfile <(printf "subjectAltName=DNS:dns.lab.lan,DNS:ldap.lab.lan,DNS:git.lab.lan,DNS:words.lab.lan,DNS:*.lab.lan")

cat lab.lan.crt lab-root.crt > lab.lan.chain.crt
openssl verify -CAfile lab-root.crt lab.lan.chain.crt
openssl verify -CAfile lab-root.crt lab.lan.crt

chmod 644 *.crt
chmod 644 *.key

