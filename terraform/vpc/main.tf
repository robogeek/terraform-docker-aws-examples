provider "aws" {
    profile   = var.aws_profile
    region    = var.aws_region
}

terraform {
  backend "local" {
    path = "../state/vpc/terraform.tfstate"
  }
}

data "aws_availability_zones" "available" {
    state = "available"
}

locals {
    config = var.configuration[var.env_name]
}
