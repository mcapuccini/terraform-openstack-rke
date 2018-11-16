# OpenStack Rancher Kubernetes Engine Module

[![Build Status](https://travis-ci.org/mcapuccini/terraform-openstack-rke.svg?branch=master)](https://travis-ci.org/mcapuccini/terraform-openstack-rke)

[Terraform](https://www.terraform.io/) module to deploy [Kubernetes](https://kubernetes.io) with [RKE](https://rancher.com/docs/rke/v0.1.x/en/) on OpenStack.

## Table of contents
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Deploy](#deploy)
- [Scale](#scale)
- [Destroy](#destroy)

## Prerequisites
On your workstation you need to:

- Install [Terraform](https://www.terraform.io/)
- Install the [terafform-provider-rke](https://github.com/yamamoto-febc/terraform-provider-rke)
- Set up the environmet by [sourcing the OpenStack RC](https://docs.openstack.org/zh_CN/user-guide/common/cli-set-environment-variables-using-openstack-rc.html) file for your project

On your OpenStack project you need to:

- Import an [RKE-compliant OS image](https://rancher.com/docs/rke/v0.1.x/en/os/#operating-system)

## Configuration

Start by creating a directory, locating into it and by creating the main Terraform configuration file:

```
mkdir deployment
cd deployment
touch main.tf
```

In `main.tf` paste and fill in the following configuration:

```hcl
module "rke" {
  source  = "mcapuccini/rke/openstack"
  # Required variables
  ssh_key_pub="" # Local path to public SSH key
  ssh_key="" # Local path to SSH key
  ssh_user="" # SSH user name (use the default user for the OS image)
  external_network_id="" # External network ID
  floating_ip_pool="" # Name of the floating IP pool (often same as the external network name)
  image_name="" # Name of an image to boot the nodes from (OS shold be RKE-compliant)
  master_flavor_name="" # Master node flavor name
  master_count=1 # Number of masters to deploy
  worker_flavor_name="" # Worker node flavor name
  worker_count=2 # Number of workers to deploy
  ignore_docker_version=false # If true RKE won't check Docker version
}
```

Init the Terraform directory by running:

```
terraform init
```

## Deploy

To deploy please run:

```
terraform apply
```

Once the deployment is done, you can configure `kubectl` and check the nodes:

```
KUBECONFIG="$PWD/kubeconfig.yml"
kubectl get nodes
```

## Scale

To scale the cluster you can increase and decrease the number of masters and workers in `main.tf` and rerun `terraform apply`.

## Destroy

You can delete the cluster by running:

```
terraform destroy
```
