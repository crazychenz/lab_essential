#!/bin/sh

mkdir -p /run/php && chown caddy:caddy /run/php
exec /usr/bin/s6-svscan /etc/s6
