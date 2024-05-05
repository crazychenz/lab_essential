# Essential Services

Essential services are the bare minimum services needed to support all other GitOps within the system. Essential services are broken up across several phases:

- **Collector** - This machine is internet connected and responsible for collecting (once) all of the required packages for building the essential services offline.

- **Host** - This is the machine responsible for hosting the essential services. This is were we'll need to ensure there is an OS that meets a number of configuration assumptions. This host does not need to be internet connected to build and/or host the essential services.

- **Services** - These are the descriptors for the essential services. Note: By design, none of the essential services are managed by GitOps.

  - Critical Package Service - HTTP server hosting relevant packages.
  - DNSMasq - DNS Server
  - Caddy - CA & HTTPS Server
  - Gitea - Git Server

