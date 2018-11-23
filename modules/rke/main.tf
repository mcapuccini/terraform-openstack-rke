# Provision RKE
resource rke_cluster "cluster" {
  nodes_conf = ["${var.node_mappings}"]

  bastion_host = {
    address      = "${var.ssh_bastion_host}"
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
    sans     = ["${var.kubeapi_sans_list}"]
  }

  ignore_docker_version = "${var.ignore_docker_version}"

  # Workaround: make sure resources are created and deleted in the right order
  provisioner "local-exec" {
    command = "# ${join(",",var.rke_cluster_deps)}"
  }
}

# Write YAML configs
locals {
  api_access       = "https://${element(var.kubeapi_sans_list,0)}:6443"
  api_access_regex = "/https://\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}:6443/"
}

resource local_file "kube_config_cluster" {
  count    = "${var.write_kube_config_cluster ? 1 : 0}"
  filename = "${path.root}/kube_config_cluster.yml"

  # Workaround: https://github.com/rancher/rke/issues/705
  content = "${replace(rke_cluster.cluster.kube_config_yaml, local.api_access_regex, local.api_access)}"
}

resource "local_file" "custer_yml" {
  count    = "${var.write_cluster_yaml ? 1 : 0}"
  filename = "${path.root}/cluster.yml"
  content  = "${rke_cluster.cluster.rke_cluster_yaml}"
}
