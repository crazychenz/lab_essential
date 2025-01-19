#!/bin/sh

ldapadd -x -w password -D "cn=admin,dc=lab,dc=lan" -f add-admins.ldif
ldapmodify -x -w password -D "cn=config,cn=config" -f permit-admins.ldif

