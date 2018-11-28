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
  default     = [22, 6443, 80, 443]
}

variable allowed_ingress_udp {
  type        = "list"
  description = "Allowed UDP ingress traffic"
  default     = []
}

variable cloudflare_enable {
  description = "If true it enables Cloudflare dynamic DNS (for this to work CLOUDFLARE_EMAIL and CLOUDFLARE_TOKEN should be set in your environment)"
  default     = false
}

variable cloudflare_domain {
  description = "Cloudflare domain to add the DNS records to (required if enable_cloudflare=true)"
  default     = ""
}

variable cloudflare_record_name {
  description = "Name for the DNS records to add (these will point to the edge nodes, you typically want a wildcard)"
  default     = "*.rke"
}

variable acme_server_url {
  description = "ACME server URL"
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable acme_registration_email {
  description = "Email for ACME registration (required if acme_enable is true)"
  default     = ""
}

variable acme_enable {
  description = "If false ACME provisioning will be skipped (if enabled cloudflare_enable must be also true)"
  default     = false
}
