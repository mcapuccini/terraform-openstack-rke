# Interpolate cluster.yml for RKE
locals {
  cluster_yml = <<EOT

nodes:
%{for node in var.node_list~}
  - address: ${node.address}
    user: ${node.user}
    role:
%{for role in node.role~}
      - ${role}
%{endfor}
    ssh_key_path: ${node.ssh_key_path}
    internal_address: ${node.internal_address}
    hostname_override: ${node.hostname_override}
    labels:
%{for key,value in node.labels~}
      ${key}: ${value}
%{endfor}
%{endfor}
EOT
}
