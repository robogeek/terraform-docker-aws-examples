provider "aws" {
  profile = data.terraform_remote_state.vpc.outputs.aws_profile
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

terraform {
  backend "local" {
    path = "../state/ec2/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../state/vpc/terraform.tfstate"
  }
}

locals {
    srv-dns       = aws_instance.srv.*.public_dns
    srv-addresses = aws_instance.srv.*.public_ip
    srv-hostnm    = var.instances.*.host_name
    srv-ssh       = var.instances.*.ssh_connect
}
