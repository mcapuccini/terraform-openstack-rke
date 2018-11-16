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
  ssh_keypair        = "${openstack_compute_keypair_v2.keypair.name}"
  role               = ["controlplane", "etcd"]
  assign_floating_ip = true
  allowed_ingress_tcp = [22, 6443]
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
  ssh_keypair      = "${openstack_compute_keypair_v2.keypair.name}"
  role             = ["worker"]
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
}

# Write kubeconfig.yaml
resource local_file "kube_cluster_yaml" {
  filename = "./kubeconfig.yml"
  content  = "${rke_cluster.cluster.kube_config_yaml}"
}
