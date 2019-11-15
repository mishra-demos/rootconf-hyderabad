data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "mishracorp"
    workspaces = {
      name = "networking-prod"
    }
  }
}

module "buycoffee-web-server" {
  source  = "mishra-demos/web-server/aws"
  version = "0.0.6-dev"

  release_url      = "https://github.com/anubhavmishra/buycoffee/releases/download/v0.0.1/buycoffee.zip"
  service_name     = "buycoffee"
  vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_id        = element(data.terraform_remote_state.vpc.outputs.public_subnets, 0)
  web_server_count = 3

  # Inventory service inventory_service_addr
  inventory_service_addr = "34.93.187.110"
}

module "dns-entry" {
  source  = "mishra-demos/route53-dns-entry/aws"
  version = "0.0.2"

  subdomain_name = "buycoffee"
  elb_dns_name   = "${module.buycoffee-web-server.elb_address}"
  elb_zone_id    = "${module.buycoffee-web-server.elb_zone_id}"
}

output "load_balancer_address" {
  value = "${module.buycoffee-web-server.elb_address}"
}

output "web_server_ips" {
  value = "${module.buycoffee-web-server.web_server_ips}"
}