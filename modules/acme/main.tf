provider "acme" {
  server_url = "${var.acme_serer_url}"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.acme_reg_email}"
}

resource "acme_certificate" "certificate" {
  account_key_pem = "${acme_registration.reg.account_key_pem}"
  common_name     = "${var.cert_common_name}"

  dns_challenge {
    provider = "cloudflare"

    config {
      CLOUDFLARE_EMAIL   = "${var.cloudflare_email}"
      CLOUDFLARE_API_KEY = "${var.cloudflare_api_key}"
    }
  }
}
