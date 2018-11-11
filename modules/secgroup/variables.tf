variable name_prefix {
  description = "Prefix for the security group name"
}

variable allowed_ingress_tcp {
  type        = "list"
  description = "Allowed TCP ingress traffic"
  default     = [22, 6443]
}

variable allowed_ingress_udp {
  type        = "list"
  description = "Allowed UDP ingress traffic"
  default     = []
}
