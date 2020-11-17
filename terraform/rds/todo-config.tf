resource "local_file" "todo-config" {
    filename = "${path.module}/rds-mysql.yaml"
    content = <<EOF
user: ${var.tododb_username}
dbname: ${var.tododb_name} 
username: ${var.tododb_username}
password: ${var.tododb_userpasswd}
params: 
    host: ${aws_db_instance.tododb.address}
    port: ${var.tododb_port}
    dialect: mysql
EOF
}