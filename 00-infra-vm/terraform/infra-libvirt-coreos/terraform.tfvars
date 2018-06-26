/*
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 -d 224.0.0.0/24 -j RETURN
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 -d 255.255.255.255/32 -j RETURN
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 ! -d 192.168.8.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 ! -d 192.168.8.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 ! -d 192.168.8.0/24 -j MASQUERADE

iptables -t filter -A FORWARD ! -i virbr1 -o virbr1 -j ACCEPT -m comment --comment "vagrant-vbox-hostonly-in"
iptables -t filter -A FORWARD -i virbr1 ! -o virbr1 -j ACCEPT -m comment --comment "vagrant-vbox-hostonly-out"

*/
project_name = "coredns"

qtd_vms = 3

vm_memory = 1024

vm_cpu = 2

network_mode = "route"

additional_disks_size = 10000000000

network_name = "net"

vm_name_prefix = "coreos"

virtual_machine_domain = "k8s.local"

linux_image_path = "/home/rafael/Downloads/coreos_production_qemu_image.img"

virtual_machine_network_address = "192.168.8.0/24"

virtual_machine_gateway = "192.168.8.1"

vm_netmask = "24"

docker_daemon_json = <<EOF
{
  "registry-mirrors": ["http://192.168.8.1:5550"],
  "bip": "192.168.6.1/24"
}
EOF

virtual_machine_dns_servers = <<EOF
  DNS=192.168.8.251
EOF

management_ssh_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEqT/AMSxWAuiANUlq7Z7gwDTsMC3xJYIwJ+JDDau/sH5XvFFQbnyM355cMu73oN9flIIEa0VmfLk9K56hRvul+dacDfZrTWgQ+CoUywennrsY4ZHwGwRvu6YPcJtzrZ0F1oqyhBmkqcb0QK05dyWOXgGBjibwLMHK2K/VUfYL/V8kg0c67J90IuV6i8F06tI1qd/0bm9qznsR7bQWUaQbhCY6D7x+4EXn03YpjwmNQXaHbET7RoOYJeVzxQn5pF6ViFnuB1Hi/R3DPOwKxgKhHd+0ts49YuyPq/Xy/OvB/+8jHpiuvwy3j2Uiw8IyXZd3yyCOZV/Iv0/Hn+jt9t6XjhODP/Ala4+ne0C31odljJSw0AuYZL6Y0Snaj8sVl6WPLF5wCi3EgvYzv2/eI+Zq3nCkA4rODbUY7OlrfSH7tdu/L8SUO8oLOk5pHY/R/VDhktnG+JfK2R7bZYui4GO9HHWTLLSvpO1yGXBHusUDW4zdfpJzdHVgrg06/5Uu/D5SfFXs52ngWEcoZxznIu+DoIrs5C4bhAAy68PS7fKioPCOheuUPuMhQe6GtZvZtGPIl2lJX1+DfuEfJmidv8EbAk5NcX8c+XqtcnUa97l4gOBN2I3wXXjoKlT/qQsld1Bt+q9W4xA08IC/IP3+amysL/uWGapRu+dN/ZR9u1y0BQ== muller.rafael@gmail.com",
]

vm_ips = [
  "192.168.8.251",
  "192.168.8.252",
  "192.168.8.253",
]
