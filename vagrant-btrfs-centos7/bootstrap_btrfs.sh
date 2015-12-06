#!/bin/bash

install_btrfs() {
  yum install -y btrfs-progs
}

create_btrfs() {
  mkfs.btrfs -L data -m raid5 -d raid5 /dev/sd[b-e]
  mkdir -p /mnt/data
  bash -c "echo /dev/disk/by-label/data /mnt/data btrfs  rw,user,exec 0 0 >> /etc/fstab"
  mount /dev/disk/by-label/data /mnt/data
}

info_btrfs() {
  btrfs filesystem show
  btrfs device usage /mnt/data
  btrfs device stats /mnt/data
}

replace_faulty() {
  btrfs replace start -f /dev/sde /dev/sdf /mnt/data
  btrfs replace status /mnt/data
}

scrub_btrfs() {
  btrfs scrub start -B -d /mnt/data
}


main() {
  install_btrfs
  create_btrfs
  info_btrfs
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
