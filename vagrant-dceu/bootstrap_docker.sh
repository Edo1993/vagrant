#!/bin/bash

permissive_iptables() {
  # need to install iptables-services, othervise the 'iptables save' command will not be available
  dnf -y install iptables-services net-tools

  iptables --flush INPUT
  iptables --flush FORWARD
  service iptables save
}

disable_selinux() {
  setenforce 0
  sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
}

#Shall be updated to fc23 once it is available
install_docker() {
  cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/22
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
  dnf install -y docker-engine-1.9.0-1.fc22
  systemctl start docker
  systemctl enable docker
  usermod -aG docker vagrant
}


main() {
  permissive_iptables
  disable_selinux
  install_docker
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
