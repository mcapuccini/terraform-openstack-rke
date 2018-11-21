# Add public key
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.cluster_prefix}-keypair"
  public_key = "${file(var.ssh_key_pub)}"
}

# Create security group
module "secgroup" {
  source      = "modules/secgroup"
  name_prefix = "${var.cluster_prefix}"
}

# Create network
module "network" {
  source              = "modules/network"
  name_prefix         = "${var.cluster_prefix}"
  external_network_id = "${var.external_network_id}"
}

# Create master node
module "master" {
  source              = "modules/node"
  count               = "${var.master_count}"
  name_prefix         = "${var.cluster_prefix}-master"
  flavor_name         = "${var.master_flavor_name}"
  image_name          = "${var.image_name}"
  network_name        = "${module.network.network_name}"
  secgroup_name       = "${module.secgroup.secgroup_name}"
  floating_ip_pool    = "${var.floating_ip_pool}"
  ssh_user            = "${var.ssh_user}"
  ssh_key             = "${var.ssh_key}"
  os_ssh_keypair      = "${openstack_compute_keypair_v2.keypair.name}"
  assign_floating_ip  = true
  allowed_ingress_tcp = [22, 6443]
  docker_version      = "${var.docker_version}"
  role                = ["controlplane", "etcd"]
}

# Create worker nodes
module "worker" {
  source           = "modules/node"
  count            = "${var.worker_count}"
  name_prefix      = "${var.cluster_prefix}-worker"
  flavor_name      = "${var.worker_flavor_name}"
  image_name       = "${var.image_name}"
  network_name     = "${module.network.network_name}"
  secgroup_name    = "${module.secgroup.secgroup_name}"
  floating_ip_pool = "${var.floating_ip_pool}"
  ssh_user         = "${var.ssh_user}"
  ssh_key          = "${var.ssh_key}"
  os_ssh_keypair   = "${openstack_compute_keypair_v2.keypair.name}"
  ssh_bastion_host = "${element(module.master.public_ip_list,0)}"
  docker_version   = "${var.docker_version}"
  role             = ["worker"]
}

# Compute dynamic dependencies for RKE provisioning step (workaround, may be not needed in 0.12)
locals {
  rke_cluster_deps = [
    "${join(",",module.master.prepare_nodes_id_list)}",
    "${join(",",module.worker.prepare_nodes_id_list)}",
    "${join(",",module.master.associate_floating_ip_id_list)}",
    "${join(",",module.master.allowed_ingress_id_list)}",
    "${join(",",module.worker.allowed_ingress_id_list)}",
    "${join(",",module.secgroup.rule_id_list)}",
    "${module.network.interface_id}",
  ]
}

# Provision RKE
resource rke_cluster "cluster" {
  nodes_conf = ["${concat(module.master.node_mappings,module.worker.node_mappings)}"]

  bastion_host = {
    address      = "${element(module.master.public_ip_list,0)}"
    user         = "${var.ssh_user}"
    ssh_key_path = "${var.ssh_key}"
    port         = 22
  }

  ignore_docker_version = "${var.ignore_docker_version}"

  # Workaround: make sure resources are created and deleted in the right order
  provisioner "local-exec" {
    command = "# ${join(",",local.rke_cluster_deps)}"
  }
}

# Write YAML configs
resource local_file "kube_config_cluster" {
  count    = "${var.write_kube_config_cluster ? 1 : 0}"
  filename = "./kube_config_cluster.yml"
  content  = "${rke_cluster.cluster.kube_config_yaml}"
}

resource "local_file" "custer_yml" {
  count    = "${var.write_cluster_yaml ? 1 : 0}"
  filename = "./cluster.yml"
  content  = "${rke_cluster.cluster.rke_cluster_yaml}"
}
