variable "node_list" {
  type = "list"

  default = [
    {
      address           = "address",
      user              = "user",
      role              = ["r1", "r2", "r3"],
      ssh_key_path      = "ssh_key_path",
      internal_address  = "internal_address",
      hostname_override = "hostname_override",
      labels = {
        k1 = "v1",
        k2 = "v2"
      }
    },
    {
      address           = "address",
      user              = "user",
      role              = ["r1", "r2", "r3"],
      ssh_key_path      = "ssh_key_path",
      internal_address  = "internal_address",
      hostname_override = "hostname_override",
      labels = {
        k1 = "v1",
        k2 = "v2"
      }
    },
  ]
}
