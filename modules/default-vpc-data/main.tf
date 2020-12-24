
///////////- INPUT VARIABLES

variable "default-vpc-name" {
    default = "default-vpc"
}

///////////- MAIN CODE

data "aws_vpcs" "default-vpc" {
    tags = {
        Name = var.default-vpc-name
    }
}

data "aws_subnet_ids" "default-vpc" {
    vpc_id = local.default-vpc-id
}

data "aws_subnet" "default-vpc" {
    count = length(local.default-vpc-subnets)
    id    = local.default-vpc-subnets[count.index]
}

///////////- LOCAL VALUES

locals {
    default-vpc-id      = tolist(data.aws_vpcs.default-vpc.ids)[0]
    default-vpc-subnets = tolist(data.aws_subnet_ids.default-vpc.ids)
    default-vpc-cidrs   = data.aws_subnet.default-vpc.*.cidr_block
}

///////////- OUTPUT VALUES

output "default_vpc_id"      { value = local.default-vpc-id }
output "default_vpc_subnets" { value = local.default-vpc-subnets }
output "default_vpc_cidrs"   { value = local.default-vpc-cidrs }
