output "network_name" {
  description = "Name of the network"

  value = "${openstack_networking_network_v2.network.name}"
}

output "interface_id" {
  description = "Router to network interface resource ID"
  value       = "${openstack_networking_router_interface_v2.interface.id}"
}
