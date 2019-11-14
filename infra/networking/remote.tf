terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mishracorp"

    workspaces {
      name = "networking-prod"
    }
  }
}
