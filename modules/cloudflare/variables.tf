variable cloudflare_enable {
  description = "If true it enables Cloudflare dynamic DNS"
}

variable cloudflare_domain {
  description = "Cloudflare domain to add the DNS records to (required if enable_cloudflare=true)"
  default     = ""
}

variable cloudflare_record_name {
  description = "Name for the DNS records to add (these will point to the edge nodes, you typically want a wildcard)"
}

variable dns_value_list {
  type = "list"
  description = "List of DNS values (an A record will be created for each fo these)"
}

variable cloudflare_email {
  description = "Cloudflare account email (required if enable_cloudflare=true)"
  default     = ""
}

variable cloudflare_api_key {
  description = "Cloudflare API key (required if enable_cloudflare=true)"
  default     = ""
}

variable dns_record_count {
  description = "DNS record count, should be equal to dns_value_list length (cannot be computed due to terraform limitations)"
}
