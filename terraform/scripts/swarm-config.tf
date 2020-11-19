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
        srv1: var.srv1_ssh_id,
        srv2: var.srv2_ssh_id,
        srv3: var.srv3_ssh_id,
        context: var.docker_context
    })
}

resource "local_file" "swarm-check" {
    filename = "${path.module}/swarm-check.sh"
    content = templatefile("./tmpl/swarm-check-tmpl.sh", {
        srv1: var.srv1_ssh_id,
        srv2: var.srv2_ssh_id,
        srv3: var.srv3_ssh_id
    })
}

