output "private_key_pem" {
  description = "The certificate's private key in PEM format"
  value = "${acme_certificate.certificate.private_key_pem}"
}

output "certificate_pem" {
  description = "The certificate in PEM format"
  value = "${acme_certificate.certificate.certificate_pem}"
}
