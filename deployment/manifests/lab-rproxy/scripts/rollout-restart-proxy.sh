#!/bin/sh

# Put this into `/etc/cron.weekly/rollout-restart-proxy.sh` and make executable.
# This is needed to reload certificates that may have been updated within the past week.

# If there is an issue with rollout restart, it may be bad certificate data.
# Check with: `nonuser@node0:/opt/state/certs$ ls -lR | grep pem`

kubectl -n work-vinnie-proxy-ns rollout restart deploy proxy-deployment