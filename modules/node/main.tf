# Create instance
resource "openstack_compute_instance_v2" "instance" {
  count       = "${var.count}"
  name        = "${var.name_prefix}-${format("%03d", count.index)}"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${var.secgroup_name}"]
}

# Allocate floating IPs (if required)
resource "openstack_compute_floatingip_v2" "floating_ip" {
  count = "${var.assign_floating_ip ? var.count : 0}"
  pool  = "${var.floating_ip_pool}"
}

# Associate floating IPs (if required)
resource "openstack_compute_floatingip_associate_v2" "floating_ip" {
  count       = "${var.assign_floating_ip ? var.count : 0}"
  floating_ip = "${element(openstack_compute_floatingip_v2.floating_ip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.instance.*.id, count.index)}"
}

# Create block storage (if required)
resource "openstack_blockstorage_volume_v2" "extra_disk" {
  count = "${var.block_storage_size > 0 ? var.count : 0}"
  name  = "${var.name_prefix}-volume-${format("%03d", count.index)}"
  size  = "${var.block_storage_size}"
}

# Attach extra disk (if required)
resource "openstack_compute_volume_attach_v2" "attach_extra_disk" {
  count       = "${var.block_storage_size > 0 ? var.count : 0}"
  instance_id = "${element(openstack_compute_instance_v2.instance.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.extra_disk.*.id, count.index)}"
}

# RKE node mappings
data "rke_node_parameter" "node_mappings" {
  count = "${var.count}"

  address           = "${var.assign_floating_ip ? element(openstack_compute_floatingip_v2.floating_ip.*.address, count.index) : element(openstack_compute_instance_v2.instance.*.network.0.fixed_ip_v4, count.index)}"
  user              = "${var.ssh_user}"
  ssh_key_path      = "${var.ssh_key}"
  internal_address  = "${element(openstack_compute_instance_v2.instance.*.network.0.fixed_ip_v4, count.index)}"
  hostname_override = "${element(openstack_compute_instance_v2.instance.*.name, count.index)}"
  roles             = "${var.role}"
  labels            = "${var.labels}"
}
