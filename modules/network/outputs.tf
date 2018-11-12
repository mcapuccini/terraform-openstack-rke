output "network_name" {
  description = "Name of the network"

  value = "${openstack_networking_network_v2.network.name}"
}
