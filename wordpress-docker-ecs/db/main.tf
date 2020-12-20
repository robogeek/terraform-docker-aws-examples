provider "aws" {
    profile   = var.aws_profile
    region    = var.aws_region
}

data "aws_vpcs" "default-vpc" {
  tags = {
    Name = "default-vpc"
  }
}

locals {
  default-vpc-id = tolist(data.aws_vpcs.default-vpc.ids)[0]
}

