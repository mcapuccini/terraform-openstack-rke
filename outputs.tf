output kube_config_cluster {
  description = "Kubeconfig file"
  value       = "${module.rke.kube_config_cluster}"
  sensitive   = true
}

output custer_yml {
  description = "RKE cluster.yml file"
  value       = "${module.rke.custer_yml}"
}
