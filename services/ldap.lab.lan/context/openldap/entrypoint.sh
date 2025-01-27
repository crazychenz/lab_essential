#!/bin/bash

/usr/sbin/sshd -f /etc/ssh/sshd_config
/usr/sbin/sssd -c /etc/sssd/sssd.conf --logger files
/bin/bash -i
