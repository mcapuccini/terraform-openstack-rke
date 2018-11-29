module "rke" {
  source  = "../../"
  ssh_key_pub="~/.ssh/newkey.pub" # Local path to public SSH key
  ssh_key="~/.ssh/newkey" # Local path to SSH key
  ssh_user="ubuntu" # SSH user name (use the default user for the OS image
  external_network_id="af006ff3-d68a-4722-a056-0f631c5a0039" # External network ID
  floating_ip_pool="Public External IPv4 network" # Name of the floating IP pool (often same as the external network name)
  image_name="Ubuntu 16.04 LTS (Xenial Xerus) - latest" # Name of an image to boot the nodes from (OS should be Ubuntu 16.04)
  master_flavor_name="ssc.xlarge" # Master node flavor name
  master_count=1 # Number of masters to deploy (should be an odd number)
  service_flavor_name="ssc.xlarge" # service node flavor name
  service_count=1 # Number of services to deploy
  ignore_docker_version=false # If true RKE won't check Docker version
  edge_flavor_name="ssc.xlarge"
  edge_count="1"
  os_username="s6725"
  os_auth_url="https://uppmax.cloud.snic.se:5000/v3"
  os_tenant_id="9301f656901b45c291887b5012f44a20"
  os_tenant_name="SNIC 2018/10-4"
  os_domain_name="snic"
}
