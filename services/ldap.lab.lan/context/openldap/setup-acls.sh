#!/bin/sh

ldapmodify -x -w password -D "cn=config,cn=config" -f /config-ldif/acls.ldif

