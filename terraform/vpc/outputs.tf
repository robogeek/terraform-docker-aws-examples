
output "aws_profile"  { value = var.aws_profile }
output "aws_region"   { value = var.aws_region  }

output "project_name" { value = var.project_name }

output "vpc_id"   { value = module.vpc-example.vpc_id }
output "vpc_arn"  { value = module.vpc-example.vpc_arn }
output "vpc_cidr" { value = module.vpc-example.vpc_cidr_block }

output "igw_id"   { value = module.vpc-example.igw_id }
output "igw_arn"  { value = module.vpc-example.igw_arn }

output "public_subnets"  { value = module.vpc-example.public_subnets }
output "private_subnets" { value = module.vpc-example.private_subnets }

output "azs"      { value = module.vpc-example.azs }
