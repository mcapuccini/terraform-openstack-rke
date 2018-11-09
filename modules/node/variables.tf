variable count {
  description = "Number of nodes to be created"
}

variable name_prefix {
  description = "Prefix for the node name"
}

variable flavor_name {
  description = "Flavor to be used for this node"
}

variable image_name {
  description = "Image to boot this node from"
}

variable ssh_user {
  description = "SSH user name"
}

variable network_name {
  description = "Name of the network to attach this node to"
}

variable secgroup_name {
  description = "Name of the security group to apply to this node"
}

variable assign_floating_ip {
  description = "If true a floating IP will be attached to this node"
  default     = false
}

variable floating_ip_pool {
  description = "Name of the floating IP pool (don't leave it empty if assign_floating_ip is true)"
  default     = ""
}

variable extra_disk_size {
  description = "If greater than 0 a block storage volume will be attached to this node"
  default     = 0
}
