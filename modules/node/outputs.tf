output rke_node_mappings {
  description = "RKE node mappings as a list of maps"
  value = "${null_resource.rke_node_mappings.*.triggers}"
}
