variable "node_mappings" {
  type        = "list"
  description = "Node mappings for RKE provisioning"
}

variable ssh_bastion_host {
  default = "Bastion SSH host"
}

variable ssh_user {
  description = "SSH user name"
}

variable ssh_key {
  description = "Path to private SSH key"
}

variable kubeapi_sans_list {
  type        = "list"
  description = "SANS for the Kubernetes server API"
}

variable ignore_docker_version {
  description = "If true RKE won't check Docker version on images"
}

variable write_kube_config_cluster {
  description = "If true kube_config_cluster.yml will be written locally"
}

variable write_cluster_yaml {
  description = "If true cluster.yml will be written locally"
}

variable "rke_cluster_deps" {
  type        = "list"
  description = "List of resources that will delay creation and deletion of the RKE provisioning resource (provide a resource output for each)"
}

variable os_username {
  description = "Openstack user name"
}

variable os_password {
  description = "Openstack tenancy password"
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
