#!/bin/bash

entropy_magic() {
  yum install -y rng-tools
  systemctl start rngd
}

install_freeipa_server() {
  yum install -y bind-utils ipa-server ipa-server-dns
}

config_freeipa_server() {
  hostname master.cloudy.site
  ipa-server-install --realm CLOUDY.SITE --domain cloudy.site -a Admin123! -p Admin123! --setup-dns --forwarder=10.0.2.3 --auto-reverse --unattended
}


main() {
  entropy_magic
  install_freeipa_server
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
