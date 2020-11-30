provider "aws" {
    profile = data.terraform_remote_state.vpc.outputs.aws_profile
    region  = data.terraform_remote_state.vpc.outputs.aws_region
}

terraform {
    backend "local" {
        path = "../state/ecs/terraform.tfstate"
    }
}

data "terraform_remote_state" "vpc" {
    backend = "local"
    config = {
        path = "../state/vpc/terraform.tfstate"
    }
}

data "terraform_remote_state" "db" {
    backend = "local"
    config = { 
        path = "../state/db/terraform.tfstate"
    }
}

resource "aws_ecs_cluster" "main" {
    name = "${data.terraform_remote_state.vpc.outputs.project_name}-ecs-cluster"
    capacity_providers = [ "FARGATE" ]
}
