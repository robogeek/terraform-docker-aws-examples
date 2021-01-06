provider "aws" {
    profile   = var.aws_profile
    region    = var.aws_region
}


/* provider "aws" {
    profile = data.terraform_remote_state.vpc.outputs.aws_profile
    region  = data.terraform_remote_state.vpc.outputs.aws_region
} */

/* data "terraform_remote_state" "vpc" {
    backend = "local"
    config = {
        path = "../terraform/state/vpc/terraform.tfstate"
    }
} */

/* data "terraform_remote_state" "db" {
    backend = "local"
    config = { 
        path = "../terraform/state/db/terraform.tfstate"
    }
} */

/* locals {
    env_name = data.terraform_remote_state.vpc.outputs.env_name
    config   = var.configuration[data.terraform_remote_state.vpc.outputs.env_name]
} */

/* locals {
    config = var.configuration[var.env_name]
} */

/* data "aws_availability_zones" "available" {
    state = "available"
} */

/* resource "aws_ecs_cluster" "main" {
    name = "${var.project_name}-ecs-cluster"
    capacity_providers = [ "FARGATE" ]
} */

