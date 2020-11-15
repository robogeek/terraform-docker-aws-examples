
output "tododb-address" { value = aws_db_instance.tododb.address }

output "tododb_id"         { value = var.tododb_id }
output "tododb_name"       { value = var.tododb_name }
output "tododb_username"   { value = var.tododb_username }
output "tododb_userpasswd" { value = var.tododb_userpasswd }
output "tododb_port"       { value = var.tododb_port }
