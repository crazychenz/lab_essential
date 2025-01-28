docker compose build cert_generator
docker compose run --rm cert_generator








 ldapsearch -x -H ldaps://ldap.lab.lan:636 -D "cn=config,cn=config" -W -b "cn=config" -s base -ZZ

ldapsearch -x -H ldaps://ldap.lab.lan -D "cn=config,cn=config" -W -b "cn=config" -s base

 ldapsearch -x -H ldap://ldap.lab.lan -D "cn=config,cn=config" -w password -b "cn=config" -s base

cp /opt/bitnami/openldap/certs/ldapserver.crt /usr/local/share/ca-certificates/ && update-ca-certificates


Add to the top of stack in common-session:
session     optional    pam_mkhomedir.so

DEBIAN_FRONTEND=noninteractive pam-auth-update --enable sss
DEBIAN_FRONTEND=noninteractive pam-auth-update --enable mkhomedir



NFS

# server
apt-get install nfs-kernel-server -y
systemctl enable --now nfs-server
mkdir -p /exports/users
mount --bind /opt/stable/lab_essential/services/ldap.lab.lan/data/users /exports/users
# In /etc/exports:
#   /exports/users 10.0.0.0/8(sec=sys,rw,no_subtree_check,mountpoint,no_root_squash,async)
exportfs -ra


# client
apt-get install nfs-common


