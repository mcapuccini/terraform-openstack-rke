variable cluster_prefix {
  description = "Name prefix for the cluster resources"
  default     = "rke"
}

variable ssh_key {
  description = "Local path to SSH key"
}

variable ssh_key_pub {
  description = "Local path to public SSH key"
}

variable ssh_user {
  description = "SSH user name (use the default user for the OS image)"
}

variable external_net_uuid {
  description = "External network UUID"
}

variable floating_ip_pool {
  description = "Name of the floating IP pool (often same as the external network name)"
}

variable image_name {
  description = "Name of an image to boot the nodes from (OS shold be RKE-compliant: https://rancher.com/docs/rke/v0.1.x/en/os/)"
}

variable master_flavor_name {
  description = "Master node flavor name"
}

variable master_count {
  description = "Number of masters to deploy"
  default = 1
}

variable worker_flavor_name {
  description = "Worker node flavor name"
}

variable worker_count {
  description = "Number of workers to deploy"
  default = 2
}
