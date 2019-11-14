output "atlantis_url" {
  value = "https://${google_compute_address.address.address}"
}