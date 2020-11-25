provider "aws" {
  profile = data.terraform_remote_state.vpc.outputs.aws_profile
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../state/vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "local"
  config = {
    path = "../state/ec2/terraform.tfstate"
  }
}

data "terraform_remote_state" "db" {
  backend = "local"
  config = {
    path = "../state/db/terraform.tfstate"
  }
}

resource "local_file" "swarm-config" {
    filename = "${path.module}/swarm-config.sh"
    content = templatefile("./tmpl/swarm-config-tmpl.sh", {
        servers: slice(data.terraform_remote_state.ec2.outputs.srv-ssh, 
                    1, length(data.terraform_remote_state.ec2.outputs.srv-ssh)),
        srv1: data.terraform_remote_state.ec2.outputs.srv-ssh[0],
        context: var.docker_context
    })
}

resource "local_file" "swarm-check" {
    filename = "${path.module}/swarm-check.sh"
    content = templatefile("./tmpl/swarm-check-tmpl.sh", {
        servers: data.terraform_remote_state.ec2.outputs.srv-ssh
    })
}

