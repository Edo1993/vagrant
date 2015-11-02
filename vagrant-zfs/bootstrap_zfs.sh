#!/bin/bash

install_zfs() {
  dnf install -y --nogpgcheck http://archive.zfsonlinux.org/fedora/zfs-release$(rpm -E %dist).noarch.rpm
  dnf install -y kernel-devel zfs
  #modprobe zfs
}

configure_raidz() {
  zpool create -f datastore raidz /dev/sd[b-e]
}

check_raidz() {
  dmesg | grep ZFS
  zpool status datastore
}

create_fs() {
  zfs create -o mountpoint=/mnt/data datastore/data
  zfs list
}

#https://romanrm.net/dd-benchmark
bechmark() {
    sync; dd if=/dev/zero of=bf bs=8k count=500000 conv=fdatasync; rm bf
}

replace_faulty() {
  zpool replace datastore /dev/sde /dev/sdf
}


main() {
  install_zfs
  #configure_raidz
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
