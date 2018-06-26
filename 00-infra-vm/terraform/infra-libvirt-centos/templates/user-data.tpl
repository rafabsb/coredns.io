#cloud-config

runcmd:
  - [setenforce, 0]
  - [sed, -ci.cloudconfig.bkp, s/SELINUX=enforcing/SELINUX=disabled/g, /etc/sysconfig/selinux]

packages:
  - git
  - iscsi-initiator-utils
  - http://192.168.5.1:8080/Downloads/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
  - http://192.168.5.1:8080/Downloads/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm

runcmd:
  - [ systemctl, daemon-reload ]
  - [ systemctl, enable, docker.service ]
  - [ systemctl, start, --no-block, docker.service ]
  - [ usermod, -aG, docker, centos]
