
output "aws_profile" {  value = var.aws_profile }
output "aws_region" {  value = var.aws_region }

output "vpc_id" {  value = aws_vpc.example.id }
output "vpc_arn" { value = aws_vpc.example.arn }
output "vpc_cidr" { value = aws_vpc.example.cidr_block }

output "igw_id" { value = aws_internet_gateway.igw.id }

output "subnet_public1_id" { value = aws_subnet.public1.id }
output "subnet_public1_az" { value = aws_subnet.public1.availability_zone }
output "subnet_public1_cidr" { value = aws_subnet.public1.cidr_block }
output "subnet_public2_id" { value = aws_subnet.public2.id }
output "subnet_public2_az" { value = aws_subnet.public2.availability_zone }
output "subnet_public2_cidr" { value = aws_subnet.public2.cidr_block }

