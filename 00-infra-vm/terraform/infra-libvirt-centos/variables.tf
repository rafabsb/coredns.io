// The hosts to use when creating virtual machines. There should be 3 hosts
// defined here.

variable "project_name" {
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

# mode can be: "nat" (default), "none", "route", "bridge"
variable "network_mode" {
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

variable "vm_ips" {
  description = "IPs v4 que serao utilizados na configuracao da VM"
  type        = "list"
}

variable "cloud_config_user_data" {
  type = "string"
}
