#!/bin/bash

generic_tools() {
  yum -y install wget curl
}

install_ssh_key() {
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCipEiaYz11WHPNtXp1pR0rahCI4wn/neej9Q4ogQp1VBzimtKaZ08t+5yenYfIOBGCC+GbpCn1ksckk2Xwj4NO9q8S5vQ7DPs9g9C4UAqHqgrP4OH+sJEM9ypHA9cO+q/Im6jSpwI0Iv9QSUViUgGvBipfhLaiBPZyI6Q3AfPXFQcCvdnblUaUV+0ioSLcjCVGiEfMDgrprUbBhjMNL7y175RolxrDsDGX6vDoW8QpwDfZicpTZj6KuBoE/7NgpGFsOB2t53O/kbBG5anSMYyD+ZEnxsP2+e7AA2u0rUrr7sF+fztPK9qj7V1ADmTNFx5w1eAnTpl/nTB9DHUcKYG5 akanto" >> /home/vagrant/.ssh/authorized_keys
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

install_docker() {
  cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/23
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
  dnf install -y docker-engine
  systemctl start docker
  systemctl enable docker
  usermod -aG docker vagrant
}


main() {
  generic_tools
  install_ssh_key
  permissive_iptables
  disable_selinux
  #install_docker
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
