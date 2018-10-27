#!/bin/bash

update_hosts_file() {
  sed -i '/cloudyx/d' /etc/hosts
}

generic_tools() {
  yum -y install wget curl
}

permissive_iptables() {
  # need to install iptables-services, othervise the 'iptables save' command will not be available
  yum -y install iptables-services net-tools

  iptables --flush INPUT
  iptables --flush FORWARD
  service iptables save
}

disable_selinux() {
  setenforce 0
  sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
}

main() {
  update_hosts_file
  generic_tools
  permissive_iptables
  disable_selinux
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
