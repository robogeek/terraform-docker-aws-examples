
output "db_name"     { value = var.db_name }
output "db_username" { value = var.db_username }
output "db_passwd"   { value = var.db_passwd }

output "wpdb-address" { value = aws_db_instance.wordpress.address }
