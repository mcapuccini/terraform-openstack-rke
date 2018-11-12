resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${var.name_prefix}-secgroup"
  description = "Security gropup for RKE"
}

resource "openstack_networking_secgroup_rule_v2" "internal_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "1"
  port_range_max    = "64535"
  remote_group_id   = "${openstack_networking_secgroup_v2.secgroup.id}"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "internal_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = "1"
  port_range_max    = "64535"
  remote_group_id   = "${openstack_networking_secgroup_v2.secgroup.id}"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ingress_tcp" {
  count = "${length(var.allowed_ingress_tcp)}"

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "${element(var.allowed_ingress_tcp, count.index)}"
  port_range_max    = "${element(var.allowed_ingress_tcp, count.index)}"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ingress_udp" {
  count = "${length(var.allowed_ingress_udp)}"

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = "${element(var.allowed_ingress_udp, count.index)}"
  port_range_max    = "${element(var.allowed_ingress_udp, count.index)}"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}
