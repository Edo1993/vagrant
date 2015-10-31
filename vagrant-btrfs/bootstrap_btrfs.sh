#!/bin/bash

install_btrfs() {
  dnf install -y btrfs-progs
}

create_btrfs() {
  mkfs.btrfs -L data -m raid1 -d raid5 /dev/sd[b-e]
  mkdir -p /mnt/data
  mount /dev/disk/by-label/data /mnt/data
}

info_btrfs() {
  btrfs fi show
}

main() {
  install_btrfs
  create_btrfs
  info_btrfs
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
