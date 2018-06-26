// The hosts to use when creating virtual machines. There should be 3 hosts
// defined here.

variable "docker_daemon_json" {
  type = "string"
}

variable "vm_memory" {
  type = "string"
}

variable "vm_cpu" {
  type = "string"
}

variable "additional_disks_size" {
  type = "string"
}

variable "linux_image_path" {
  type = "string"
}

# the name used by libvirt
variable "network_name" {
  type = "string"
}

// The name prefix of the virtual machines to create.
variable "vm_name_prefix" {
  type = "string"
}

// The domain name to set up each virtual machine as.
variable "virtual_machine_domain" {
  type = "string"
}

// The network address for the virtual machines, in the form of 10.0.0.0/24.
variable "virtual_machine_network_address" {
  type = "string"
}

// The default gateway for the network the virtual machines reside in.
variable "virtual_machine_gateway" {
  type = "string"
}

# mode can be: "nat" (default), "none", "route", "bridge"
variable "network_mode" {
  type = "string"
}

// The DNS servers for the network the virtual machines reside in.
variable "virtual_machine_dns_servers" {
  type = "string"
}

// A list of SSH keys that will be pushed to the "core" user on each CoreOS
// virtual machine. This allows for the management of each host after
// provisioning.
variable "management_ssh_keys" {
  type = "list"
}

variable "qtd_vms" {
  description = "How many VMs will be created."
  type        = "string"
}

variable "project_name" {
  type = "string"
}

variable "vm_ips" {
  description = "IPs v4 que serao utilizados na configuracao da VM"
  type        = "list"
}

variable "vm_netmask" {
  description = "Netmask a ser definida em cada maquina"
  type        = "string"
}

#########################

variable "unit_options" {
  description = ""
  default     = []
  type        = "list"
}

variable "version" {
  description = ""
  default     = "v3.2.7"
}

variable "write_files" {
  description = ""
  default     = false
}

variable "asset_dir" {
  description = ""
  default     = "assets"
}

variable "name" {
  description = ""
  default     = ""
}

variable "ip_addresses" {
  type = "list"

  default = [
    "127.0.0.1",
  ]
}

variable "client_advertise_fqdn" {
  description = ""
  type        = "list"
  default     = ["$${element(var.vm_ips, count.index)}"]
}

variable "peer_advertise_fqdn" {
  description = ""
  type        = "list"
  default     = ["$${element(var.vm_ips, count.index)}"]
}

variable "client_listen_host" {
  description = ""
  default     = "0.0.0.0"
}

variable "peer_listen_host" {
  description = ""
  default     = "0.0.0.0"
}

variable "client_tls_dir" {
  description = ""
  default     = "/etc/ssl/etcd"
}

variable "peer_tls_dir" {
  description = ""
  default     = "/etc/ssl/certs/etcd"
}

variable "server_tls_dir" {
  description = ""
  default     = "/etc/ssl/certs/etcd"
}

variable "client_port" {
  description = ""
  default     = 2379
}

variable "peer_port" {
  description = ""
  default     = 2380
}
