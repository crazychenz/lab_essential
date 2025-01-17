---
sidebar_position: 2
title: OS Install
---

I will quickly rush through many of my conventions for setting up a VM for the development environment with some standard settings. If we're running on a dedicated machine, we'd likely run through many of these settings for the bare metal host, but then install a VM anyway due to a virtual machine's portability and ease with which we can backup and restore.

## OS Install

1. For this manual, we're using Debian 12.

- [Download Debian 12.9 DVD](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-12.9.0-amd64-DVD-1.iso).
- Note: For bad links, try looking in the [Debian CD Image Archive](https://cdimage.debian.org/mirror/cdimage/archive/).

2. Within the Linux environment, I use VirtualBox because of its cost and simplicity. Absent of VirtualBox, I prefer to use qemu or libvirt/virsh/virtmanager with KVM. You can of course use whatever hypervisor works for you.

3. Whether you are using a VM or physical host, I recommend adding a second hard disk as "external storage". Plan for failed disks. When using VMs, have your external virtual disk live on another physical disk for redundancy. I recommend 32GB-64GB as a reasonable minimum, but in reality you can go down to 1GB-4GB if you're struggling to find the space.

4. Start up the VM with a Install ISO to install the operating system.

5. Run through the various dialogs to setup the OS as desired.

- Recommended at least 4 GB RAM, 32 GB Disk with LVM all in one partition.
- Optionally omit the Desktop Environments. (We can add something more minimal later.)

6. If you are connected to a network with access to an `apt` repo, after the first boot, ensure that all packages are upgraded. In the terminal, run something like the following:

  ```sh
  sudo su -c "apt-get update && apt-get dist-upgrade"
  ```

7. An absolute must for every system is SSH. Install OpenSSH (via apt) with `apt-get install openssh-server openssh-client`. (Note: It may have already been install).

8. Setup user SSH keys: `ssh-keygen` (Accept defaults). Note: I generally use a passphrase for keys used by humans and no passphrase for keys used for automation such as a `cicd` user on the K8s machine.

9. For disk management of the K8s machine and Docker Dev machine, I prefer to use LVM partitions. You can choose to use btrfs or zfs, but I prefer the loose coupling of LVM from the file system.

    Note: I create a number of LVM partitions so that theoretically I have the flexibility to shrink and reclaim some low level partition table space if needed. This isn't a common situation in well funded production environments, but remains tactically prudent when working on a shoe string budget where you may not have the ability to purchase additional storage on a whim.

    ```sh
    sudo parted
    (parted) select /dev/sdb
    (parted) print
    (parted) mkpart primary 0% 25%
    (parted) mkpart primary 0% 25%
    (parted) mkpart primary 0% 25%
    (parted) mkpart primary 0% 25%
    (parted) set 1 lvm on
    (parted) set 2 lvm on
    (parted) set 3 lvm on
    (parted) set 4 lvm on
    ```

10. Setup LVM configuration. For this, I used:

    - Managed Config (2G) - for managed config.
    - State Store (8G) - for service state.
    - Secure Store (6G) - for security service state.
    - Imports Store (8G) - for imported files.
    - Artifact Store (16G) - for repository
    - Backup Store (??)

    ```sh
    sudo apt-get install lvm2
    sudo pvcreate /dev/sdb1
    sudo pvcreate /dev/sdb2
    sudo pvcreate /dev/sdb3
    sudo pvcreate /dev/sdb4
    sudo vgcreate external_vg /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
    sudo lvcreate -n managedcfg_lv -L 2G external_vg
    sudo lvcreate -n state_lv -L 8G external_vg
    sudo lvcreate -n secure_lv -L 6G external_vg
    sudo lvcreate -n imports_lv -L 8G external_vg
    sudo lvcreate -n artifacts_lv -L 32G external_vg
    sudo mkfs.ext4 /dev/mapper/external_vg-managedcfg_lv
    sudo mkfs.ext4 /dev/mapper/external_vg-state_lv
    sudo mkfs.ext4 /dev/mapper/external_vg-secure_lv
    sudo mkfs.ext4 /dev/mapper/external_vg-imports_lv
    sudo mkfs.ext4 /dev/mapper/external_vg-artifacts_lv
    sudo mkdir -p /opt/{managedcfg,state,secure,imports,artifacts}
    ```

    - To have the LVM partitions auto-mount when the system boots, run the following shell script to output fstab entries to the console. You can then copy and paste that output as entries in `/etc/fstab`:

      ```sh
      pfx=/dev/mapper/external_vg-
      for p in state secure imports artifacts
      do
        echo $(sudo blkid ${pfx}${p}_lv | cut -d ' ' -f2) /opt/${p} ext4
      done
      ```

    - LVM should now be setup.

11. Install a Text Editor

    - `apt-get install vim` (because Vim is the dominant terminal text editor.) `;-)`

    - Naturally, emacs and nano are also options. What's important here is that you have an editor that works in the terminal window that you are comfortable with.

12. Install HTTP CLI: `apt-get install curl`.

13. Add yourself (`whoami`) to docker group and reset your terminal (e.g. logout and login.)

    - Note: VSCode has an existing bug that prevents groups updates in Remote-SSH without restarting the server. User's have [reported this issue](https://github.com/microsoft/vscode-remote-release/issues/5813), but due to the aggressive ticket pruning employed by the upstream VSCode team, the issue has gone unresolved. As the comments elude to, you can restart the VSCode server with: `ps uxa | grep .vscode-server | awk '{print $2}' | xargs kill -9`. If that doesn't work, restarting the entire kernel (i.e the system) should work.

14. Ensure git and python3 are installed: `sudo apt-get install git python3`

15. Optionally configure a static IP on the primary interface. I prefer to use the `/etc/network/interfaces` interface. Therefore I remove the other network managers:

  ```sh
  sudo systemctl disable --now systemd-networkd
  sudo systemctl disable --now systemd-resolved # For DNS
  sudo systemctl disable --now NetworkManager
  sudo apt install ifupdown # For /etc/network/interfaces
  ```

  I've found `dhclient` to sometimes be overly invasive. If you are using static addresses anyway, you can disable the `dhclient` (without completely removing it) with:

  ```sh
  sudo chmod 644 /sbin/dhclient
  sudo killall dhclient
  ```

  Here is an example `/etc/network/interfaces` file with a static address:

  ```interfaces
  auto lo
  iface lo inet loopback

  auto ens33
  iface ens33 inet static
  address 192.168.1.5/24
  broadcast 192.168.1.255
  gateway 192.168.1.254
  ```

  Restart the network after updates with: `/etc/init.d/networking restart`.

16. **OS Install Complete**
