output "node_mappings" {
  description = "RKE node mappings"
  value       = ["${data.rke_node_parameter.node_mappings.*.json}"]
}

output "public_ip_list" {
  description = "List of floating IP addresses"
  value       = ["${openstack_compute_floatingip_v2.floating_ip.*.address}"]
}

output "prepare_nodes_id_list" {
  description = "Prepare nodes provisioner resource ID list"
  value       = ["${null_resource.prepare_nodes.*.id}"]
}

output "allowed_ingress_id_list" {
  description = "Allowed ingress resource ID list"
  value       = ["${module.allowed_ingress.rule_id_list}"]
}

output "associate_floating_ip_id_list" {
  description = "Associate floating IP resource ID list"
  value       = ["${openstack_compute_floatingip_associate_v2.associate_floating_ip.*.id}"]
}
