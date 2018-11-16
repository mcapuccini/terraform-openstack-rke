output "node_mappings" {
  description = "RKE node mappings"
  value       = ["${data.rke_node_parameter.node_mappings.*.json}"]
}

output "public_ip_list" {
  description = "List of floating IP addresses (one per node)"
  value       = ["${openstack_compute_floatingip_v2.floating_ip.*.address}"]
}
