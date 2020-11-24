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

module "vpc-example" {
    source = "terraform-aws-modules/vpc/aws"

    name       = "${var.project_name}-${var.env_name}-vpc"
    cidr       = local.config.vpc_cidr

    enable_nat_gateway     = local.config.enable_nat_gateway
    single_nat_gateway     = local.config.single_nat_gateway
    one_nat_gateway_per_az = local.config.one_nat_gateway_per_az
    create_igw             = local.config.create_igw
    enable_dns_support     = local.config.enable_dns_support
    enable_dns_hostnames   = local.config.enable_dns_hostnames

    azs             = data.aws_availability_zones.available.names
    public_subnets  = local.config.public_subnet_cidrs

}
