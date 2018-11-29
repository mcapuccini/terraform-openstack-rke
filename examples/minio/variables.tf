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
  default     = "ubuntu"
}

variable external_network_id {
  description = "External network ID"
}

variable floating_ip_pool {
  description = "Name of the floating IP pool (often same as the external network name)"
}

variable image_name {
  description = "Name of an image to boot the nodes from (OS should be Ubuntu 16.04)"
}

variable master_flavor_name {
  description = "Master node flavor name"
}

variable master_count {
  description = "Number of masters to deploy (should be an odd number)"
  default     = 1
}

variable service_flavor_name {
  description = "Service node flavor name"
}

variable service_count {
  description = "Number of service nodes to deploy"
  default     = 2
}

variable edge_flavor_name {
  description = "Edge node flavor name"
}

variable edge_count {
  description = "Number of edge nodes to deploy (this should be at least 1)"
  default     = 1
}

variable ignore_docker_version {
  description = "If true RKE won't check Docker version on images"
  default     = false
}

variable docker_version {
  description = "Docker version (should be RKE-compliant: https://rancher.com/docs/rke/v0.1.x/en/os/#software)"
  default     = "17.03"
}

variable write_kube_config_cluster {
  description = "If true kube_config_cluster.yml will be written locally"
  default     = true
}

variable write_cluster_yaml {
  description = "If true cluster.yml will be written locally"
  default     = true
}

variable master_assign_floating_ip {
  description = "If true a floating IP is assigned to each master node"
  default     = false
}

variable service_assign_floating_ip {
  description = "If true a floating IP is assigned to each service node"
  default     = false
}

variable edge_assign_floating_ip {
  description = "If true a floating IP is assigned to each edge node"
  default     = true
}

variable allowed_ingress_tcp {
  type        = "list"
  description = "Allowed TCP ingress traffic"
  default     = [22, 6443]
}

variable allowed_ingress_udp {
  type        = "list"
  description = "Allowed UDP ingress traffic"
  default     = []
}

variable os_username {
  description = "Openstack user name"
}

variable os_password {
  description = "Openstack tenancy password"
  default     = ""
}

variable os_auth_url {
  description = "Openstack auth url"
}

variable os_tenant_id {
  description = "Openstack tenant/project id"
}

variable os_tenant_name {
  description = "Openstack tenant/project name"
}

variable os_domain_name {
  description = "Openstack domain name"
}
