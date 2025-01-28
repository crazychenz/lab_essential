#!/bin/bash

/usr/sbin/sshd -f /etc/ssh/sshd_config
/usr/sbin/sssd -c /etc/sssd/sssd.conf --logger files
# No trivial way to run NFS from container.
#/usr/sbin/automount &

cp /certs/lab-root.crt /usr/local/share/ca-certificates/lab-root.crt
#cp /certs/lab-intermediate.crt /usr/local/share/ca-certificates/lab-intermediate.crt
chmod 644 /usr/local/share/ca-certificates/lab-root.crt
#chmod 644 /usr/local/share/ca-certificates/lab-intermediate.crt
update-ca-certificates

/bin/bash -i
