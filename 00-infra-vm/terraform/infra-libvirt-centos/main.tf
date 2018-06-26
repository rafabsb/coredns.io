resource "libvirt_network" "net_iface_0" {
  name      = "${var.project_name}${var.network_name}"
  mode      = "${var.network_mode}"
  domain    = "${var.virtual_machine_domain}"
  addresses = ["${var.virtual_machine_network_address}"]
}

resource "libvirt_volume" "os_vm_img" {
  name   = "${var.project_name}_os_vm_img"
  source = "${var.linux_image_path}"
  format = "qcow2"
}

resource "libvirt_volume" "main_disks" {
  count          = "${var.qtd_vms}"
  name           = "main_os_disk_${var.project_name}${count.index}.qcow2"
  base_volume_id = "${libvirt_volume.os_vm_img.id}"
}

resource "libvirt_volume" "additional_disks" {
  count = "${var.qtd_vms}"
  name  = "disk_${var.project_name}_${count.index}.qcow2"
  size  = "${var.additional_disks_size}"
}

resource "libvirt_cloudinit" "commoninit" {
  name               = "${var.project_name}_commoninit.iso"
  local_hostname     = "${var.project_name}_${count.index}"
  ssh_authorized_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEqT/AMSxWAuiANUlq7Z7gwDTsMC3xJYIwJ+JDDau/sH5XvFFQbnyM355cMu73oN9flIIEa0VmfLk9K56hRvul+dacDfZrTWgQ+CoUywennrsY4ZHwGwRvu6YPcJtzrZ0F1oqyhBmkqcb0QK05dyWOXgGBjibwLMHK2K/VUfYL/V8kg0c67J90IuV6i8F06tI1qd/0bm9qznsR7bQWUaQbhCY6D7x+4EXn03YpjwmNQXaHbET7RoOYJeVzxQn5pF6ViFnuB1Hi/R3DPOwKxgKhHd+0ts49YuyPq/Xy/OvB/+8jHpiuvwy3j2Uiw8IyXZd3yyCOZV/Iv0/Hn+jt9t6XjhODP/Ala4+ne0C31odljJSw0AuYZL6Y0Snaj8sVl6WPLF5wCi3EgvYzv2/eI+Zq3nCkA4rODbUY7OlrfSH7tdu/L8SUO8oLOk5pHY/R/VDhktnG+JfK2R7bZYui4GO9HHWTLLSvpO1yGXBHusUDW4zdfpJzdHVgrg06/5Uu/D5SfFXs52ngWEcoZxznIu+DoIrs5C4bhAAy68PS7fKioPCOheuUPuMhQe6GtZvZtGPIl2lJX1+DfuEfJmidv8EbAk5NcX8c+XqtcnUa97l4gOBN2I3wXXjoKlT/qQsld1Bt+q9W4xA08IC/IP3+amysL/uWGapRu+dN/ZR9u1y0BQ== muller.rafael@gmail.com"

  # user_data          = "${var.cloud_config_user_data}"
}

resource "libvirt_domain" "my_machine" {
  count  = "${var.qtd_vms}"
  name   = "${var.project_name}${count.index}"
  memory = "${var.vm_memory}"
  vcpu   = "${var.vm_cpu}"

  cloudinit = "${libvirt_cloudinit.commoninit.id}"

  network_interface {
    network_id = "${libvirt_network.net_iface_0.id}"
    addresses  = ["${element(var.vm_ips, count.index)}"]
  }

  disk {
    volume_id = "${libvirt_volume.main_disks.*.id[count.index]}"
  }

  # disk {
  #   volume_id = "${libvirt_volume.additional_disks.*.id[count.index]}"
  # }
}
