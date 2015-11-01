#!/bin/bash

install_cockpit() {
     dnf -y install cockpit
     systemctl start cockpit
}

disable_firewalld() {
     systemctl stop firewalld
     systemctl disable firewalld
}

main() {
  install_cockpit
  disable_firewalld
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
