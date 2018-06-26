/*
iptables -t filter -A FORWARD -d 192.168.8.0/24 ! -i virbr1 -o virbr1 -j ACCEPT -m comment --comment "vagrant-vbox-hostonly-in"
iptables -t filter -A FORWARD -s 192.168.8.0/24 -i virbr1 ! -o virbr1 -j ACCEPT -m comment --comment "vagrant-vbox-hostonly-out"
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 ! -o virbr1 -j MASQUERADE -m comment --comment "vagrant-vbox-hostonly-nat-out"
*/

project_name = "coredns_centos"

qtd_vms = 3

vm_memory = 2048

vm_cpu = 2

network_mode = "route"

additional_disks_size = 50000000000

network_name = "net"

vm_name_prefix = "k8scentos"

virtual_machine_domain = "k8s.local"

linux_image_path = "/home/rafael/Downloads/CentOS-7-x86_64-GenericCloud.qcow2"

virtual_machine_network_address = "192.168.8.0/24"

management_ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEqT/AMSxWAuiANUlq7Z7gwDTsMC3xJYIwJ+JDDau/sH5XvFFQbnyM355cMu73oN9flIIEa0VmfLk9K56hRvul+dacDfZrTWgQ+CoUywennrsY4ZHwGwRvu6YPcJtzrZ0F1oqyhBmkqcb0QK05dyWOXgGBjibwLMHK2K/VUfYL/V8kg0c67J90IuV6i8F06tI1qd/0bm9qznsR7bQWUaQbhCY6D7x+4EXn03YpjwmNQXaHbET7RoOYJeVzxQn5pF6ViFnuB1Hi/R3DPOwKxgKhHd+0ts49YuyPq/Xy/OvB/+8jHpiuvwy3j2Uiw8IyXZd3yyCOZV/Iv0/Hn+jt9t6XjhODP/Ala4+ne0C31odljJSw0AuYZL6Y0Snaj8sVl6WPLF5wCi3EgvYzv2/eI+Zq3nCkA4rODbUY7OlrfSH7tdu/L8SUO8oLOk5pHY/R/VDhktnG+JfK2R7bZYui4GO9HHWTLLSvpO1yGXBHusUDW4zdfpJzdHVgrg06/5Uu/D5SfFXs52ngWEcoZxznIu+DoIrs5C4bhAAy68PS7fKioPCOheuUPuMhQe6GtZvZtGPIl2lJX1+DfuEfJmidv8EbAk5NcX8c+XqtcnUa97l4gOBN2I3wXXjoKlT/qQsld1Bt+q9W4xA08IC/IP3+amysL/uWGapRu+dN/ZR9u1y0BQ== muller.rafael@gmail.com",
]

vm_ips = [
  "192.168.8.251",
  "192.168.8.252",
  "192.168.8.253",
]

cloud_config_user_data = <<EOF
runcmd:
  - [setenforce, 0]
  - [sed, -ci.cloudconfig.bkp, s/SELINUX=enforcing/SELINUX=disabled/g, /etc/sysconfig/selinux]

packages:
  - iscsi-initiator-utils

runcmd:
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, docker.service ]
  - [ systemctl, start, --no-block, docker.service ]
  - [ usermod, -aG, docker, centos]
EOF

/*
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/

https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm

*/

