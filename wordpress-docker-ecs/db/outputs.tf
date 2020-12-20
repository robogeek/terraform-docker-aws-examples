
output "db_name"     { value = var.db_name }
output "db_username" { value = var.db_username }
output "db_passwd"   { value = var.db_passwd }

output "wpdb-address" { value = aws_db_instance.wordpress.address }

output "wp_id"       { value = aws_efs_file_system.wordpress.id }
output "wp_arn"      { value = aws_efs_file_system.wordpress.arn }

output "default_vpc_id"  { value = local.default-vpc-id }
