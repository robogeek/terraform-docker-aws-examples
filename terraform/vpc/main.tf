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

    enable_nat_gateway     = true
    single_nat_gateway     = false
    one_nat_gateway_per_az = false
    create_igw             = true
    enable_dns_support     = var.enable_dns_support
    enable_dns_hostnames   = var.enable_dns_hostnames

    azs             = data.aws_availability_zones.available.names
    public_subnets  = [ var.public1_cidr, var.public2_cidr, var.public3_cidr ]

}
