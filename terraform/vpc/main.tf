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

module "vpc-example" {
    source = "terraform-aws-modules/vpc/aws"

    name       = "${var.project_name}-vpc"
    cidr       = var.vpc_cidr

    enable_nat_gateway     = var.enable_nat_gateway
    single_nat_gateway     = var.single_nat_gateway
    one_nat_gateway_per_az = var.one_nat_gateway_per_az
    create_igw             = var.create_igw
    enable_dns_support     = var.enable_dns_support
    enable_dns_hostnames   = var.enable_dns_hostnames

    azs             = data.aws_availability_zones.available.names
    public_subnets  = var.public_subnet_cidrs

}
