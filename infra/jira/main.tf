provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "demo" {
  ami           = "ami-08692d171e3cf02d6"
  instance_type = "t2.micro"

  tags = {
    Name = "web-1"
  }
}

#provider "jira" {}
#
#resource "jira_issue" "example" {
#  issue_type  = "Task"
#  project_key = "INFRA"
#  summary     = "Created using Terraform"
#
#  // description is optional  
#  description = "Web Server IP: ${aws_instance.demo.private_ip}, Instance ID: ${aws_instance.demo.id}"
#}
