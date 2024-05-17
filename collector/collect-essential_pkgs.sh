#!/bin/sh

mkdir -p essential_pkgs/alpine
mkdir -p essential_pkgs/debian
mkdir -p essential_pkgs/docker
mkdir -p essential_pkgs/github

docker compose up

git bundle create essential_pkgs/lab_essential.bundle --all

#tar -cf critical_pkgs.tar essential_pkgs
#TARFLAG="-J" # xz compression
TARFLAG="" # no compression
cat >essential_pkgs_install.sh <<SH_EOF
#!/bin/sh
sudo install -m 0777 -d /opt/imports/
sudo install -m 0777 -d /opt/state/
sudo install -m 0777 -d /opt/artifacts/
cd /opt/imports/

base64 -d <<TAR_EOF | tar $TARFLAG -xf -
SH_EOF

tar $TARFLAG -cf - essential_pkgs | base64 -w 72 >>essential_pkgs_install.sh

cat >>essential_pkgs_install.sh <<SH_EOF
TAR_EOF

cd essential_pkgs
git clone lab_essential.bundle
SH_EOF

chmod +x essential_pkgs_install.sh
