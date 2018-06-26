data "template_file" "docker_daemon" {
  template = "${file("${path.module}/templates/daemon.json.tpl")}"

  vars {
    mirror              = "\"http://192.168.8.1:5550\""
    insecure_registries = "\"http://192.168.8.1:5550\",\"asd\""
  }
}

resource "null_resource" "example" {
  triggers = {
    json = "${data.template_file.docker_daemon.rendered}"
  }
}
