data "google_client_config" "current" {}

provider "kubernetes" {
  load_config_file = false
  host             = "${google_container_cluster.cluster.endpoint}"

  cluster_ca_certificate = "${base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)}"
  token                  = "${data.google_client_config.current.access_token}"
}