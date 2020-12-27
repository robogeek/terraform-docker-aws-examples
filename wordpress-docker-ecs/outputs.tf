output "db_name"     { value = var.db_name }
output "db_username" { value = var.db_username }
output "db_passwd"   { value = var.db_passwd }

output "wpdb-address" { value = aws_db_instance.wordpress.address }

output "default_vpc_id"  { value = module.default-vpc.default_vpc_id }
output "default_vpc_subnets" { value = module.default-vpc.default_vpc_subnets }
output "default_vpc_cidrs" { value = module.default-vpc.default_vpc_cidrs }

output "wp_id"       { value = aws_efs_file_system.wordpress.id }
output "wp_arn"      { value = aws_efs_file_system.wordpress.arn }

output "efs_id"      { value = aws_efs_file_system.wordpress.id }