# OpenStack Rancher Kubernetes Engine Module

[![Build Status](https://travis-ci.org/mcapuccini/terraform-openstack-rke.svg?branch=master)](https://travis-ci.org/mcapuccini/terraform-openstack-rke)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/mcapuccini/rke/openstack)


[Terraform](https://www.terraform.io/) module to deploy [Kubernetes](https://kubernetes.io) with [RKE](https://rancher.com/docs/rke/v0.1.x/en/) on [OpenStack](https://www.openstack.org/).

An updated version for Terraform 0.12+ and newest terraform-rke-provider is available [here](https://github.com/remche/terraform-openstack-rke).

## Table of contents
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Deploy](#deploy)
- [Scale](#scale)
- [Destroy](#destroy)

## Prerequisites
On your workstation you need to:

- Install [Terraform](https://www.terraform.io/)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Install [helm](https://docs.helm.sh/using_helm/#installing-helm)
- Install the [terafform-provider-rke](https://github.com/yamamoto-febc/terraform-provider-rke)
- Set up the environmet by [sourcing the OpenStack RC](https://docs.openstack.org/zh_CN/user-guide/common/cli-set-environment-variables-using-openstack-rc.html) file for your project

In your OpenStack project you need:

- An Ubuntu 16.04 image
- At least one available floating IP

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
  ssh_key_pub="" # Local path to public SSH key
  ssh_key="" # Local path to SSH key
  external_network_id="" # External network ID
  floating_ip_pool="" # Name of the floating IP pool (often same as the external network name)
  image_name="" # Name of an image to boot the nodes from (OS should be Ubuntu 16.04)
  master_flavor_name="" # Master node flavor name
  master_count=1 # Number of masters to deploy (should be an odd number)
  service_flavor_name="" # Service node flavor name (service nodes are general purpose)
  service_count=2 # Number of service nodes to deploy
  edge_flavor_name="" # Edge node flavor name (edge nodes run ingress controller and balance the API)
  edge_count=1 # Number of edge nodes to deploy (should be at least 1)
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
KUBECONFIG="$PWD/kube_config_cluster.yml"
kubectl get nodes
```

## Scale

To scale the cluster you can increase and decrease the number of workers in `main.tf` and rerun `terraform apply`.

## Destroy

You can delete the cluster by running:

```
terraform destroy
```
