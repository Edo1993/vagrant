#!/bin/bash

#https://github.com/docker/dceu_tutorials/blob/master/6-networking.md


#./etcd --advertise-client-urls http://10.0.0.10:4001 --listen-client-urls http://0.0.0.0:4001
start_kv() {
  docker run -d -p 8500:8500 -h consul --name consul progrium/consul -server -bootstrap
  curl -L https://github.com/coreos/etcd/releases/download/v2.2.1/etcd-v2.2.1-linux-amd64.tar.gz -o etcd-v2.2.1-linux-amd64.tar.gz
  tar xzvf etcd-v2.2.1-linux-amd64.tar.gz
  cd etcd-v2.2.1-linux-amd64
  ./etcd --advertise-client-urls http://10.0.0.10:4001 --listen-client-urls http://0.0.0.0:4001 > etcd.log &
}

docker_conf_consul() {
  sudo sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/docker daemon -H fd:\/\/ -H tcp:\/\/0.0.0.0:2376 --selinux-enabled=false --cluster-store=consul:\/\/10.0.0.10:8500\/network --cluster-advertise=enp0s8:2375/' /usr/lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker
}

docker_conf_etcd() {
  sudo sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/docker daemon -H fd:\/\/ -H tcp:\/\/0.0.0.0:2376 --selinux-enabled=false --cluster-store=etcd:\/\/10.0.0.10:4001 --cluster-advertise=enp0s8:2375/' /usr/lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker
}

calico_setup() {
  # get latest calico running
  export ETCD_AUTHORITY="10.0.0.10:4001"
  sudo sh -c 'echo "Defaults env_keep +=\"ETCD_AUTHORITY\"" >>/etc/sudoers'
  wget https://github.com/projectcalico/calico-docker/releases/download/v0.11.0/calicoctl
  sudo chmod +x calicoctl
  sudo ./calicoctl node --libnetwork
}

testenv() {
  sudo dnf -y install net-tools iperf3 qperf
  docker pull akanto/net-perf
  # docker network create --driver=overlay --subnet=10.10.10.0/24 RED
  # docker network create --driver=calico --subnet=10.10.20.0/24 BLUE
  # iperf3 -s
  # iperf3 -c 10.0.0.11 -i 1 -t 30
  # iperf3 -c 10.10.10.2 -i 1 -t 30
  # docker run -it --name container1h --net host akanto/net-perf bash
  # docker run -it --name container2h --net host akanto/net-perf bash
  # docker run -it --name container1 --net RED akanto/net-perf bash
  # docker run -it --name container2 --net RED akanto/net-perf bash
  # docker run -it --name container1c --net BLUE akanto/net-perf bash
  # docker run -it --name container2c --net BLUE akanto/net-perf bash
  # qperf
  # qperf 10.10.10.3 tcp_bw tcp_lat

}

main() {
  set -x
  commands=("start_kv" "docker_conf_consul" "docker_conf_etcd" "calico_setup" "testenv")
  select cmd_to_execute in "${commands[@]}"; do
    case $cmd_to_execute in
      "start_kv") start_kv;;
      "docker_conf_consul") docker_conf_consul;;
      "docker_conf_etcd") docker_conf_etcd;;
      "calico_setup") calico_setup;;
      "testenv") testenv;;
    esac
    break
  done
  set +x
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
