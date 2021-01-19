provider "aws" {
    profile = local.vpc-outputs.aws_profile
    region  = local.vpc-outputs.aws_region
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

locals {
    vpc-outputs = data.terraform_remote_state.vpc.outputs
    db-outputs  = data.terraform_remote_state.db.outputs
}

resource "aws_ecs_cluster" "main" {
    name = "${local.vpc-outputs.project_name}-ecs-cluster"
    capacity_providers = [ "FARGATE" ]
}
