variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-f"
}

variable "project" {
  description = "The ID of the Google Cloud project"
}

variable "credentials" {
  description = "GCP credentials file data"
}

variable "credentials_file_path" {
  default = "~/Downloads/hc-da-test-18206310bae8.json"
}

## Alantis related variables
variable "atlantis_github_user" {
  default = "mishra-demos"
}

variable "atlantis_container" {
  default = "runatlantis/atlantis:latest"
}

variable "atlantis_github_user_token" {
}

variable "atlantis_repo_whitelist" {
  default = "github.com/mishra-demos*"
}

variable "atlantis_tfe_token" {
}

## Buycoffee inventory related
variable "buycoffee_inventory_image" {
  default = "anubhavmishra/buycoffee-inventory:latest"
}

variable "buycoffee_inventory_port" {
  default = 8081
}
