resource "libvirt_network" "net_iface_0" {
  name      = "${var.project_name}_${var.network_name}"
  mode      = "${var.network_mode}"
  domain    = "${var.virtual_machine_domain}"
  addresses = ["${var.virtual_machine_network_address}"]
}

resource "libvirt_volume" "coreos_stable_img" {
  name   = "coreos_stable_img"
  source = "${var.linux_image_path}"
}

resource "libvirt_volume" "main_disks" {
  name           = "${var.project_name}_OS_${count.index}.qcow2"
  base_volume_id = "${libvirt_volume.coreos_stable_img.id}"
  count          = "${var.qtd_vms}"
}

resource "libvirt_volume" "additional_disks" {
  name  = "${var.project_name}_disk_${count.index}.qcow2"
  size  = "${var.additional_disks_size}"
  count = "${var.qtd_vms}"
}

resource "libvirt_domain" "my_machine" {
  count           = "${var.qtd_vms}"
  name            = "${var.project_name}_${var.vm_name_prefix}-${count.index}"
  coreos_ignition = "${libvirt_ignition.ignition.*.id[count.index]}"
  memory          = "${var.vm_memory}"
  vcpu            = "${var.vm_cpu}"

  network_interface {
    network_name = "${libvirt_network.net_iface_0.name}"
  }

  disk {
    volume_id = "${libvirt_volume.main_disks.*.id[count.index]}"
  }

  disk {
    volume_id = "${libvirt_volume.additional_disks.*.id[count.index]}"
  }
}
