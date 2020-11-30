
output "aws_profile" {  value = var.aws_profile }
output "aws_region"  {  value = var.aws_region }

output "project_name" { value = var.project_name }

output "vpc_id"   { value = aws_vpc.example.id }
output "vpc_arn"  { value = aws_vpc.example.arn }
output "vpc_cidr" { value = aws_vpc.example.cidr_block }

output "igw_id"   { value = aws_internet_gateway.igw.id }
output "igw_arn"   { value = aws_internet_gateway.igw.arn }

// output "vpc_id"   { value = module.vpc-example.vpc_id }
// output "vpc_arn"  { value = module.vpc-example.vpc_arn }
// output "vpc_cidr" { value = module.vpc-example.vpc_cidr_block }

// output "igw_id"   { value = module.vpc-example.igw_id }
// output "igw_arn"  { value = module.vpc-example.igw_arn }

output "public_subnets"  { value = aws_subnet.public.*.id }
output "private_subnets" { value = aws_subnet.private.*.id }

output "public_subnets_cidr"  { value = aws_subnet.public.*.cidr_block }
output "private_subnets_cidr" { value = aws_subnet.private.*.cidr_block }

output "public_subnets_full"  { value = aws_subnet.public }
output "private_subnets_full" { value = aws_subnet.private }

// output "public_subnets"  { value = module.vpc-example.public_subnets }
// output "private_subnets" { value = module.vpc-example.private_subnets }

output "azs"      { value = data.aws_availability_zones.available.names }

// output "azs"      { value = module.vpc-example.azs }

output "env_name" { value = var.env_name }
