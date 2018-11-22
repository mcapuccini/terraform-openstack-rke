# Add public key
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.cluster_prefix}-keypair"
  public_key = "${file(var.ssh_key_pub)}"
}

# Create security group
module "secgroup" {
  source              = "modules/secgroup"
  name_prefix         = "${var.cluster_prefix}"
  allowed_ingress_tcp = "${var.allowed_ingress_tcp}"
  allowed_ingress_udp = "${var.allowed_ingress_udp}"
}

# Create network
module "network" {
  source              = "modules/network"
  name_prefix         = "${var.cluster_prefix}"
  external_network_id = "${var.external_network_id}"
}

# Create master node
module "master" {
  source             = "modules/node"
  count              = "${var.master_count}"
  name_prefix        = "${var.cluster_prefix}-master"
  flavor_name        = "${var.master_flavor_name}"
  image_name         = "${var.image_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  floating_ip_pool   = "${var.floating_ip_pool}"
  ssh_user           = "${var.ssh_user}"
  ssh_key            = "${var.ssh_key}"
  os_ssh_keypair     = "${openstack_compute_keypair_v2.keypair.name}"
  ssh_bastion_host   = "${element(module.edge.public_ip_list,0)}"
  docker_version     = "${var.docker_version}"
  assign_floating_ip = "${var.master_assign_floating_ip}"
  role               = ["controlplane", "etcd"]

  labels = {
    node_type = "master"
  }
}

# Create service nodes
module "service" {
  source             = "modules/node"
  count              = "${var.service_count}"
  name_prefix        = "${var.cluster_prefix}-service"
  flavor_name        = "${var.service_flavor_name}"
  image_name         = "${var.image_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  floating_ip_pool   = "${var.floating_ip_pool}"
  ssh_user           = "${var.ssh_user}"
  ssh_key            = "${var.ssh_key}"
  os_ssh_keypair     = "${openstack_compute_keypair_v2.keypair.name}"
  ssh_bastion_host   = "${element(module.edge.public_ip_list,0)}"
  docker_version     = "${var.docker_version}"
  assign_floating_ip = "${var.service_assign_floating_ip}"
  role               = ["worker"]

  labels = {
    node_type = "service"
  }
}

# Create edge nodes
module "edge" {
  source             = "modules/node"
  count              = "${var.edge_count}"
  name_prefix        = "${var.cluster_prefix}-edge"
  flavor_name        = "${var.edge_flavor_name}"
  image_name         = "${var.image_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  floating_ip_pool   = "${var.floating_ip_pool}"
  ssh_user           = "${var.ssh_user}"
  ssh_key            = "${var.ssh_key}"
  os_ssh_keypair     = "${openstack_compute_keypair_v2.keypair.name}"
  docker_version     = "${var.docker_version}"
  assign_floating_ip = "${var.edge_assign_floating_ip}"
  role               = ["worker"]

  labels = {
    node_type = "edge"
  }
}

# Compute dynamic dependencies for RKE provisioning step (workaround, may be not needed in 0.12)
locals {
  rke_cluster_deps = [
    "${join(",",module.master.prepare_nodes_id_list)}",       # Master stuff ...
    "${join(",",module.master.allowed_ingress_id_list)}",
    "${join(",",module.service.prepare_nodes_id_list)}",      # Service stuff ...
    "${join(",",module.service.allowed_ingress_id_list)}",
    "${join(",",module.edge.prepare_nodes_id_list)}",         # Edge stuff ...
    "${join(",",module.edge.allowed_ingress_id_list)}",
    "${join(",",module.edge.associate_floating_ip_id_list)}",
    "${join(",",module.secgroup.rule_id_list)}",              # Other stuff ...
    "${module.network.interface_id}",
  ]
}

# Provision RKE
resource rke_cluster "cluster" {
  nodes_conf = ["${concat(module.master.node_mappings,module.service.node_mappings,module.edge.node_mappings)}"]

  bastion_host = {
    address      = "${element(module.edge.public_ip_list,0)}"
    user         = "${var.ssh_user}"
    ssh_key_path = "${var.ssh_key}"
    port         = 22
  }

  ingress = {
    provider = "nginx"

    node_selector = {
      node_type = "edge"
    }
  }

  authentication = {
    strategy = "x509"
    sans     = ["${module.edge.public_ip_list}"]
  }

  ignore_docker_version = "${var.ignore_docker_version}"

  # Workaround: make sure resources are created and deleted in the right order
  provisioner "local-exec" {
    command = "# ${join(",",local.rke_cluster_deps)}"
  }
}

# Write YAML configs
locals {
  api_access       = "https://${element(module.edge.public_ip_list,0)}:6443"
  api_access_regex = "/https://\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}:6443/"
}

resource local_file "kube_config_cluster" {
  count    = "${var.write_kube_config_cluster ? 1 : 0}"
  filename = "./kube_config_cluster.yml"

  # Workaround: https://github.com/rancher/rke/issues/705
  content = "${replace(rke_cluster.cluster.kube_config_yaml, local.api_access_regex, local.api_access)}"
}

resource "local_file" "custer_yml" {
  count    = "${var.write_cluster_yaml ? 1 : 0}"
  filename = "./cluster.yml"
  content  = "${rke_cluster.cluster.rke_cluster_yaml}"
}
