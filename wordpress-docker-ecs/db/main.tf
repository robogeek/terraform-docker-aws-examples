provider "aws" {
    profile   = var.aws_profile
    region    = var.aws_region
}

data "aws_vpcs" "default-vpc" {
  tags = {
    Name = "default-vpc"
  }
}

data "aws_subnet_ids" "default-vpc" {
  vpc_id = local.default-vpc-id
}

locals {
  default-vpc-id = tolist(data.aws_vpcs.default-vpc.ids)[0]
  default-vpc-subnets = tolist(data.aws_subnet_ids.default-vpc.ids)
}
