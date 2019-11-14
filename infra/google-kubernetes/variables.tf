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
