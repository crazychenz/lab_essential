---
sidebar_position: 3
title: Essential Services
---

To repeat, the minimal environment is composes of essential services that can be generalized as:

- Container Runtime
- DNS
- CA & HTTPS
- Git & Artifact Repositories

These essential service setup will go through the following 3 phases:

- **Collection** of critical packages to build and import for minimal GitOps functionality.
- **Building** of various docker images with the critical packages from our development environment.
- **Deployment** of the essential services in an initial configuration before bootstrapping.

<!-- All of these are captured in the [`lab_essentials`](https://github.com/crazychenz/lab_essential) repository. -->

## Collection

Ensure you've cloned the [`lab_essentials`](https://github.com/crazychenz/lab_essential) repository and are within its top folder:

```sh
git clone https://github.com/crazychenz/lab_essential.git
cd lab_essential
```

If you haven't already installed docker, you can setup your (Debian) apt environment by running:

<!-- TODO: newgrp does not work -->

```sh
sudo ./install-docker.sh
newgrp docker
```

With your new found docker powers, you can now run the collection process.

```sh
cd collector
./collect-essential_pkgs.sh
```

This will generate a `essential_pkgs_install.sh` file (~2GB) that you'll need to copy to a offline machine or K8S machine that has no internet. This file can be moved via a Shared Folder, a usb drive, an ISO, or a local network connection. In the case of a local network connection, I recommend `scp`:

```sh
scp essential_pkgs_install.sh user@offlinedevhost:/home/user/
```

## Building

Once the `essential_pkgs_install.sh` has been transfered, execute it to expand the various dependencies into the system. Everything will be installed into `/opt`.

```sh
sudo ./essential_pkgs_install.sh
```

Once the essential packages have been unpacked, you can remove the install script (or squirrel it away where its not taking up valuable space). 

If no internet on the docker build machine, install docker from offline.

```sh
cd /opt/imports/essential_pkgs/lab_essential/services
sudo ./install-docker-offline.sh
newgrp docker
```

Build the essential service images:

```sh
cd /opt/imports/essential_pkgs/lab_essential/services
./build-images.sh
```

## Deployment

Ensure that the k3s host SSH service is listening on port 2222 (**not the default port 22**). This usually involves uncommenting a line and changing a value in `/etc/ssh/sshd_config` followed by `/etc/init.d/ssh restart` _or_ `systemctl restart sshd`.

Enter the `lab_essential/deployment` folder to install K3s, install essential images via K3s's CRI, and deploy the initial k8s GitOps services.

Optionally enable user access to `crictl` with:

```sh
sudo groupadd containerd
sudo chgrp containerd /var/run/containerd/containerd.sock
sudo adduser cicd containerd
```

If the VM you are using is completely offline, you'll need to setup a default route for a single interface so install-k3s.sh knows what network to listen on.

```sh
cd /opt/imports/essential_pkgs/lab_essential/deployment
sudo ./install-k3s.sh
sudo ./import-cri-images.sh
./deploy-baseline-services.sh
```

It may take a few moments for everything to get to "Running". You can monitor
everything by continually running `kubectl get pods -A`

## DNS Setup

Test that DNS is working from dnsmasq.

```sh
nslookup git.lab 192.168.1.5 # Or whatever your node IP is.
curl -k https://git.lab
```

Change `/etc/resolv.conf` to non-localhost interface IP (e.g. 192.168.1.5) on k8s node. Verify coredns is reporting from dnsmasq. Do a `kubectl rollout reset ...` if not.

**Note:** You can not use localhost DNS because a docker build would not be able to access the correct network namespace without running network host mode.

## Install Caddy Certificate in k8s node

```sh
sudo curl -k https://tls.lab/certs/root.crt \
  -o /usr/local/share/ca-certificates/lab-root.crt
sudo update-ca-certificates

# Restart docker (if installed) for the update to take effect
sudo systemctl restart docker
```

## Get-All

Install a plugin that does a _complete_ `kubectl get-all`.

```sh
sudo tar --transform='s/get-all-amd64-linux/kubectl-get_all/' \
  -xf /opt/imports/essential_pkgs/github/ketall/get-all-amd64-linux.tar.gz \
  -C /usr/local/bin/ get-all-amd64-linux
```

Test with: `kubectl get-all`

## Kubectl Autocomplete

Install kubectl bash completions:

```sh
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "alias kc=kubectl" >> ~/.bashrc
echo "complete -o default -F __start_kubectl kc" >> ~/.bashrc
```

TODO: Refactor Gitea with Postgres?

## Initialize Gitea

- Visit `https://git.lab` from a web browser.
- Keep all of the defaults except ... Create an admin account (e.g. `ladmin`).
- Save changes.

## Setup Authentication Service

<!-- TODO: Setup FreeIPA or LDAP -->


## Configure Gitea

- Once Gitea has initialized, you should be logged in as the admin. You can chose
to continue doing everything as the admin if you are the only one that will
ever use the repository. Assuming you intend to have multiple users (including
automated bot accounts), there are several things you'll want to do:

- Create a `cicd` Gitea user.
- Import an SSH key for the system user that will have access to the `cicd` account (generated by `ssh-keygen`). I recommend creating a matching `cicd` system account.
<!-- TODO: Need to consider the order of operations here if we use FreeIPA or LDAP. -->
- Create the following organizations in Gitea:
  - `lab`, `dockerhub`, `ghcr.io`, `docker`, `actions`.

**Note:** From this point on, we'll be saving new docker images to gitea.

Login to the gitea docker repository from any accounts that will need access:

```sh
docker login -u cicd git.lab
```










<!-- TODO: Deploy Gitea Action Runner -->

Fetch the runner token from Gitea. ("Site Administration -> Actions -> Runners -> Create new Runner")

Start the runner with Docker Compose.

```sh
cd /opt/imports/essential_pkgs/lab_essential/services
RUNNER_TOKEN="token goes here" docker compose up -d gitea_sys_runner
```

## FluxCD

<!-- TODO: Not essential -->

Install flux onto system.

`sudo tar -xzof /opt/imports/essential_pkgs/github/fluxcd/flux_*_linux_amd64.tar.gz -C /usr/local/bin`

In our Gitea applications (https://git.lab), create `lab/flux-config` Gitea repo.

Check pre-installation conditions:

`KUBECONFIG=/etc/rancher/k3s/k3s.yaml flux check --pre`

Bootstrap flux:

```sh
KUBECONFIG=/etc/rancher/k3s/k3s.yaml \
flux bootstrap git \
  --url=ssh://git@git.lab/lab/flux-config \
  --branch=deploy \
  --private-key-file=/home/cicd/.ssh/id_rsa \
  --path=clusters/lab \
  --components-extra image-reflector-controller,image-automation-controller
```

Verify flux health with:

`KUBECONFIG=/etc/rancher/k3s/k3s.yaml flux check`




## FreeIPA

FreeIPA container requires user namespaces. When enabling user namespaces with container runtimes, you can no longer use `--network host`. (Possibly a work around with docker bridge networking?) UID/GIDs of mounted volumes files in host paths may not be what you expect.

/etc/docker/daemon.json

```json
{
  "data-root": "/opt/docker/data-root",
  "userns-remap": "default"
}
```

Must set a hostname that is FQDN. Hostname must have 3 parts. This is why I used `ipa.lab.lan` instead of what I really wanted (`ipa.lab`).

```sh
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
```

Run the following to get a krb ticket generated in the container's `/tmp` folder:

```sh
docker exec -ti ipa.lab.lan kinit admin
```

If it fails, try again a few times.

When accessing `https://ipa.lab.lan` from a web browser, a web server (not in a web form) will pop-up. Keep clicking cancel until you get to the web form login. If you attempt to login with `admin`, it may say the session is expired. Keep trying and it should work on the 2nd or 3rd try.

Things To Investigate:

- Running FreeIPA in K8s. Note: K8s has no _official_ user namespaces support. K3s supports user namespaces via containerd configurations. Note: host networking and host paths will behave differently. `:(`.
- Install FreeIPA in docker compose and/or kubernetes.
- What is the process involved with using FreeIPA LDAP?
- What is the process involved with using FreeIPA DNS?
- What is the process involved with using FreeIPA CA?
- What is the process involved with putting a reverse proxy in front of FreeIPA?

Initial Thoughts:

- FreeIPA is a bloated and over secured suite of tools with poor documentation, poor user experience, and not a lot of value above piecing together all the parts I need manually. There are some, "I wish that was turn key" kinds of things that come with FreeIPA, but the heft and demands the toolset make without permitting me to easily waive them is driving me away.