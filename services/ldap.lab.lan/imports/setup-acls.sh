#!/bin/sh

(sleep 5 && ldapmodify -x -H ldapi:// -w password -D "cn=config,cn=config" -f /ldifs/acls.ldif-config) &

