variable name_prefix {
  description = "Prefix for the network name"
}

variable subnet_cidr {
  description = "Subnet CIDR"
  default     = "10.0.0.0/16"
}

variable external_net_uuid {
  description = "External network UUID"
}

variable dns_nameservers {
  description = "DNS nameservers"
  default     = "8.8.8.8,8.8.4.4"
}
