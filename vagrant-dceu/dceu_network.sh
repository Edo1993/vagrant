#!/bin/bash

#https://github.com/docker/dceu_tutorials/blob/master/6-networking.md#task-2-configure-the-engine-to-use-key-value-store



start_kv() {
  docker run -d -p 8500:8500 -h consul --name consul progrium/consul -server -bootstrap
}

replace_docker_conf() {
  sudo sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/docker daemon -H fd:\/\/ -H tcp:\/\/0.0.0.0:2376 --selinux-enabled=false --cluster-store=consul:\/\/10.0.0.10:8500\/network --cluster-advertise=enp0s8:2375/' /usr/lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker
}

main() {
  set -x
  commands=("start_kv" "replace_docker_conf")
  select cmd_to_execute in "${commands[@]}"; do
    case $cmd_to_execute in
      "start_kv") start_kv;;
      "replace_docker_conf") replace_docker_conf;;
    esac
    break
  done
  set +x
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
