resource "openstack_networking_network_v2" "network" {
  name           = "${var.name_prefix}-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = "${var.name_prefix}-subnet"
  network_id      = "${openstack_networking_network_v2.network.id}"
  cidr            = "${var.subnet_cidr}"
  ip_version      = 4
  dns_nameservers = ["${var.dns_nameservers}"]
  enable_dhcp     = true
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.name_prefix}-router"
  external_network_id = "${var.external_network_id}"
}

resource "openstack_networking_router_interface_v2" "interface" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet.id}"
}
