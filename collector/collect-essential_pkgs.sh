#!/bin/sh

mkdir -p essential_pkgs/alpine
mkdir -p essential_pkgs/debian
mkdir -p essential_pkgs/docker
mkdir -p essential_pkgs/github

docker compose up

git bundle create essential_pkgs/lab_essential.bundle --all

TARFLAG="" # optionally add compression flag (gzip=>-z, bzip2=>-j, xz=>-J)
cat >essential_pkgs_install.sh <<SH_EOF
#!/bin/sh
sudo install -m 0777 -d /opt/imports/
sudo install -m 0777 -d /opt/state/
sudo install -m 0777 -d /opt/artifacts/
sed '1,9d' \$0 | tar -C /opt/imports -x
cd /opt/imports/essential_pkgs
git clone lab_essential.bundle
exit 0
# Verbatim tar data following this 9th line.
SH_EOF
tar $TARFLAG -c essential_pkgs >>essential_pkgs_install.sh
chmod +x essential_pkgs_install.sh

