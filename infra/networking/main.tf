provider "aws" {
  region  = "ap-south-1"
}

module "vpc" {
  source = "mishra-demos/vpc/aws"

  name = "mishracorp-vpc1"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "production"
  }
}

