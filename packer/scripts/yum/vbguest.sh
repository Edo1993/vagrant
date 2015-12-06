#!/usr/bin/env bash

#http://www.if-not-true-then-false.com/2010/install-virtualbox-guest-additions-on-fedora-centos-red-hat-rhel/

prerequisites() {
  yum install -y gcc kernel-devel kernel-headers dkms make bzip2 perl
  mkdir /tmp/virtualbox
}

cleanup() {
  yum remove -y gcc kernel-devel kernel-headers dkms make bzip2 perl
  rmdir /tmp/virtualbox
  rm /home/vagrant/*.iso
}

install() {
  ## Current running kernel on Fedora, CentOS 7/6 and Red Hat (RHEL) 7/6 ##
  export KERN_DIR=/usr/src/kernels/`uname -r`
  export VBOX_VERSION=$(cat /home/vagrant/.vbox_version)

  mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /tmp/virtualbox
  sh /tmp/virtualbox/VBoxLinuxAdditions.run
  umount /tmp/virtualbox
}

main() {
  prerequisites
  install
  cleanup
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
