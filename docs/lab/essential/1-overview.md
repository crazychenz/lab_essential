---
sidebar_position: 1
title: Start Here
---

## Description

The following pages describe a GitOps Driven Stack (GODS). GODS is a documented process and baseline for initializing an opinionated development environment setup aims to be minimalistic with realistic complexity, security, and functionality with a modest level of good practices.

In more down to earth terms: Our goal is to have a Developer Workstation (DD) environment where we can develop and test with docker and docker compose (or whatever we want). Once we're happy with our changes, we perform a `git push` (to a specific branch) to trigger the automatic CI/CD process deploy our updates to our K8s cluster (KD). (All done completely offline.)

<!-- A turn key solution for this kind of process would be nice to have. The reality is that I don't have that kind of time, and we can achieve something with similar value by providing prebuilt virtual machines disk images or similar. Adjacent to a disk image, providing K8s manifests that are tested with the provided stack would be a much easier product to maintain than something with infinite options. -->

## Assumptions and Constraints

Before we begin, I want to express a number of uncommon assumptions and constraints we'll be working with.

- **Clear demarcation between online and offline.** - I want to be able to rebuild (or recover) the foundational components of the environment **without access to the internet**. The simple solution to this is to have the bare minimum packages required to install a number of core packages: K8s, Dnsmasq, Caddy, and Gitea.

- **Not everything is K8s** - I make use of K8s in my environment as a daemon manager, _not_ a high availability or multi-node cluster. This encourages modular and containerized services across the system.

  - Docker compose is a great tool for testing small cohesive applications in isolation, but when you begin to build a bigger system with more moving parts (that you want to manage via GitOps with high fidelity), K8s is dominant in that problem space.

  - I work in lab environments that are a mix of bare metal platforms, virtual machines, containers, windows, linux, macos, android, and others. The diversity of technology we want to be able to spin up forbids us from thinking in terms of "cloud" and IaaS. Hence, we're using K8s to manage what we can, but the services within K8s must provide functionality to non-cloud-able applications.

## Overview

When I refer to a _machine_, I mean an environment with its own kernel. This could be a bare metal platform or a virtual machine. (It does not however include containers.)

As part of the GODS setup, we need to initialize what I refer to as the essential services.

- Container Runtimes
- DNS Service
- CA Management & HTTPS Service
- Git & Artifact Repositories

In general, there are 3 phases to accomplish this:

- **Collection** of critical packages to build and import for minimal GitOps functionality.
- **Building** of various docker images with the critical packages from our development environment.
- **Deployment** of the essential services in an initial configuration before bootstrapping.

These phases can happen across any number of machines, but at a minimum we'll need 2 machines. One machine that is connected to the internet and another machine that may be completely disconnected from all networks. The online machine is responsible for collecting all of the essential packages that we will require to build minimal GODS offline.

The online machine can be any common linux system with a modern version of docker, docker-buildx, and docker-compose v2. All of the collection of the packages happens in containers.

The offline machine (at the moment) is assumed to be a Debian 12 (Bookworm) Linux distribution. Once the essential packages bundle has been built in the online machine, you only need to move the `essential_pkgs_install.sh` file to the offline machine and you should have everything required to setup the minimal environment. Note: It is recommended to leave the Debian 12 DVD connected to the offline machine to be able to install common packages that may not have been installed during the OS setup phase.

Finally, once you have the essential services all setup, you can use my repository of projects and manifests to begin to flesh out the docker-compose projects and k8s deployments as desired. Or go a completely different direction to suite your needs.