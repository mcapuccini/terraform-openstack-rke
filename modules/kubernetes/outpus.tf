output kube_config_cluster {
  description = "Kubeconfig file"

  # Workaround: https://github.com/rancher/rke/issues/705
  value     = "${replace(rke_cluster.cluster.kube_config_yaml, local.api_access_regex, local.api_access)}"
  sensitive = true
}

output custer_yml {
  description = "RKE cluster.yml file"
  value       = "${rke_cluster.cluster.rke_cluster_yaml}"
}
