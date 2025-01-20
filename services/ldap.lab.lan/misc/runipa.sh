#!/bin/sh

docker run -ti --rm \
  --name ipa.lab.lan \
  -h ipa.lab.lan \
  --add-host ipa.lab.lan:192.168.1.6 \
  --add-host dockerhost:host-gateway \
  -v $(pwd)/data:/data:Z \
  -p 443:443 -p 80:80 -p 389:389 -p 636:636 -p 53:53/tcp -p 53:53/udp \
  freeipa/freeipa-server:rocky-9 \
  --setup-dns --auto-reverse $@



  #--network host \
