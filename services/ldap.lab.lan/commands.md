 ldapsearch -x -H ldaps://ldap.lab.lan:636 -D "cn=config,cn=config" -W -b "cn=config" -s base -ZZ

ldapsearch -x -H ldaps://ldap.lab.lan -D "cn=config,cn=config" -W -b "cn=config" -s base

 ldapsearch -x -H ldap://ldap.lab.lan -D "cn=config,cn=config" -w password -b "cn=config" -s base

cp /opt/bitnami/openldap/certs/ldapserver.crt /usr/local/share/ca-certificates/ && update-ca-certificates
