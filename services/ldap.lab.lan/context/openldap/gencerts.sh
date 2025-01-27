#!/bin/bash

#openssl req -x509 -nodes -days 9999 -newkey rsa:2048 -keyout ldapserver.key -out ldapserver.crt
openssl req -new -newkey rsa:2048 -nodes -keyout ldap-key.pem -out ldap-req.pem \
  -subj "/CN=ldap.lab.lan" -extensions v3_req \
  -config <( \
    echo "[v3_req]"; \
    echo "keyUsage = keyEncipherment, digitalSignature"; \
    echo "extendedKeyUsage = serverAuth"; \
    echo "subjectAltName = @alt_names"; \
    echo "[alt_names]"; \
    echo "DNS.1 = ldap.lab.lan" \
    ) && \
  openssl x509 -req -in ldap-req.pem -signkey ldap-key.pem -out ldap-cert.pem \
    -days 9999 -extfile <(echo "[v3_req]"; echo "subjectAltName=DNS:ldap.lab.lan")


#    echo "[req]"; \
#    echo "distinguished_name=req_distinguished_name"; \
#    echo "req_extensions=v3_req"; \
