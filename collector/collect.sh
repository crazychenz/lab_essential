#!/bin/sh

docker compose -f collect-docker-compose.yml up

install -m 0777 -d data/scripts
install -m 0777 -d data/context
cp * data/scripts/

tar -cf data.tar data