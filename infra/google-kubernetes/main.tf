# See https://cloud.google.com/compute/docs/load-balancing/network/example

provider "google" {
  region      = var.region
  project     = var.project
  credentials = "${file(var.credentials_file_path)}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

data "google_container_engine_versions" "versions" {
  project  = var.project
  location = var.region_zone
}

resource "google_container_cluster" "cluster" {
  name               = "atlantis-${random_id.suffix.dec}"
  project            = var.project
  enable_legacy_abac = true
  initial_node_count = 5
  location           = var.region_zone
  min_master_version = "${data.google_container_engine_versions.versions.latest_master_version}"
  node_version       = "${data.google_container_engine_versions.versions.latest_node_version}"
}

resource "google_compute_address" "atlantis" {
  name    = "atlantis-load-balancer"
  region  = var.region
  project = var.project
}

resource "google_compute_address" "buycoffee-inventory" {
  name    = "buycoffee-inventory-load-balancer"
  region  = var.region
  project = var.project
}

output "atlantis_ip_address" {
  value = "${google_compute_address.atlantis.address}"
}

output "buycoffee_inventory_url" {
  value = "http://${google_compute_address.buycoffee-inventory.address}"
}
