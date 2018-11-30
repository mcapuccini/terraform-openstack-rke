# Configure provider
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_api_key}"
}

# Create DNS records if required
resource "cloudflare_record" "dns_record" {
  count  = "${var.cloudflare_enable ? var.dns_record_count : 0}"
  domain = "${var.cloudflare_domain}"
  name   = "${var.cloudflare_record_name}"
  value  = "${element(var.dns_value_list, count.index)}"
  type   = "A"
}
