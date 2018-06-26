data "ignition_systemd_unit" "etcd_service_unit" {
  name    = "etcd-member.service"
  enabled = "true"

  dropin = [
    {
      name = "20-clct-etcd-member.conf"

      content = <<EOF
[Unit]
Requires=coreos-metadata.service
After=coreos-metadata.service

[Service]
EnvironmentFile=/run/metadata/coreos
ExecStart=
  ExecStart=/usr/lib/coreos/etcd-wrapper $ETCD_OPTS
  --name="${var.project_name}${var.vm_name_prefix}${count.index}"
  --listen-peer-urls="http://${element(var.vm_ips, count.index)}:2380"
  --listen-client-urls="http://0.0.0.0:2379"
  --initial-advertise-peer-urls="http://${element(var.vm_ips, count.index)}:2380"
  --advertise-client-urls="http://${element(var.vm_ips, count.index)}:2379"

  --initial-cluster-token="etcd-cluster-1"
  --initial-cluster="infra0=http://192.168.8.252:2380,infra1=http://192.168.8.253:2380"
  --initial-cluster-state="new"
EOF
    },
  ]
}

data "ignition_systemd_unit" "flannel_service_unit" {
  name    = "flanneld.service"
  enabled = "true"

  dropin = [
    {
      name = "20-clct-flannel.conf"

      content = <<EOF
[Service]
ExecStart=
ExecStart=/usr/lib/coreos/flannel-wrapper $FLANNEL_OPTS \
  --etcd-prefix="/flannel/network"
EOF
    },
  ]
}

data "ignition_systemd_unit" "docker_socket" {
  name    = "docker-tcp.socket"
  enabled = "true"

  content = <<EOF
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=2375
Service=docker.service
BindIPv6Only=both

[Install]
WantedBy=sockets.target
EOF
}

data "ignition_systemd_unit" "flannel_service_unit2" {
  name = "flanneld.service"

  dropin = [
    {
      name = "50-network-config.conf"

      content = <<EOF
[Service]
ExecStartPre=/usr/bin/etcdctl set /flannel/network/config '{ "Network": "10.1.0.0/16" }'
EOF
    },
  ]
}

data "ignition_file" "hostname" {
  count      = "${var.qtd_vms}"
  filesystem = "root"
  path       = "/etc/hostname"
  mode       = "0644"

  content {
    content = "${var.project_name}${var.vm_name_prefix}${count.index}"
  }
}

data "ignition_file" "docker_daemon" {
  filesystem = "root"
  path       = "/etc/docker/daemon.json"
  mode       = "0644"

  content {
    content = "${var.docker_daemon_json}"
  }
}

data "ignition_networkd_unit" "example" {
  count = "${var.qtd_vms}"
  name  = "00-eth0.network"

  content = <<EOF
[Match]
Name=eth0

[Network]
${var.virtual_machine_dns_servers}
Address=${element(var.vm_ips, count.index)}
Gateway=${var.virtual_machine_gateway}
EOF
}

########################################################################

# tls random key for root auto access to configure
resource "tls_private_key" "example_provisioning_ssh_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

data "ignition_user" "root_user" {
  name                = "root"
  ssh_authorized_keys = ["${var.management_ssh_keys}"]

  # ssh_authorized_keys = ["${tls_private_key.example_provisioning_ssh_key.public_key_openssh}"]
  password_hash = "$1$xyz$5g8MbFX.qpsReBdkZF5st1"
}

data "ignition_user" "core_user" {
  name                = "core"
  ssh_authorized_keys = ["${var.management_ssh_keys}"]
  password_hash       = "$1$xyz$5g8MbFX.qpsReBdkZF5st1"
}

data "ignition_config" "example" {
  count = "${var.qtd_vms}"

  # systemd = [
  #   "${data.ignition_systemd_unit.etcd_service_unit.id}",
  #   "${data.ignition_systemd_unit.docker_socket.id}",
  # ]

  networkd = ["${data.ignition_networkd_unit.example.*.id[count.index]}"]
  users = [
    "${data.ignition_user.root_user.id}",
    "${data.ignition_user.core_user.id}",
  ]
  files = [
    "${data.ignition_file.hostname.*.id[count.index]}",
  ]

  #    "${data.ignition_file.docker_daemon.id}",

  # filesystems = [
  #   "${data.ignition_filesystem.data_fs.id}",
  # ]
}

resource "libvirt_ignition" "ignition" {
  count   = "${var.qtd_vms}"
  name    = "ignition-${count.index}"
  content = "${data.ignition_config.example.*.rendered[count.index]}"
}
