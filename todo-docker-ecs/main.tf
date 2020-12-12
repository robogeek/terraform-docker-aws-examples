provider "aws" {
    profile = data.terraform_remote_state.vpc.outputs.aws_profile
    region  = data.terraform_remote_state.vpc.outputs.aws_region
}

data "terraform_remote_state" "vpc" {
    backend = "local"
    config = {
        path = "../terraform/state/vpc/terraform.tfstate"
    }
}

data "terraform_remote_state" "db" {
    backend = "local"
    config = { 
        path = "../terraform/state/db/terraform.tfstate"
    }
}

locals {
    env_name = data.terraform_remote_state.vpc.outputs.env_name
    config   = var.configuration[data.terraform_remote_state.vpc.outputs.env_name]

    vpc_arn  = data.terraform_remote_state.vpc.outputs.vpc_arn
    vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_ecs_cluster" "main" {
    name = "${data.terraform_remote_state.vpc.outputs.project_name}-ecs-cluster"
    capacity_providers = [ "FARGATE" ]
}
