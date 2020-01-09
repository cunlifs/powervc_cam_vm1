provider "openstack" {
  insecure = true
}

variable "number_of_instances" {}

resource "random_id" "rand" {
    byte_length = 2
}

resource "openstack_compute_instance_v2" "single-vm" {
  count     = "${var.number_of_instances}"
  name      = "${format("aix-vm-${random_id.rand.hex}-%02d", count.index+1)}"
  image_name  = "${var.openstack_image_name}"
  flavor_name = "${var.openstack_flavor_name}"

  network {
    name = "${var.openstack_network_name}"
    fixed_ip_v4 = "${var.openstack_IP_address}"
  }

  # Specify the ssh connection
  connection {
    user     = "${var.image_id_username}"
    password = "${var.image_id_password}"
    timeout  = "10m"
  }
}

output "single-vm-ip" {
  value = "${openstack_compute_instance_v2.single-vm.*.network.0.fixed_ip_v4}"
}

output "single-vm-name" {
  value = "${openstack_compute_instance_v2.single-vm.name}"
}
