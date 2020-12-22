
resource "aws_secretsmanager_secret" "wpdb-accessss" {
    name = "wpdb-accessss"
}

resource "aws_secretsmanager_secret_version" "wpdb-accessss" {
    secret_id     = aws_secretsmanager_secret.wpdb-accessss.id
    secret_string = jsonencode({
        db_host: aws_db_instance.wordpress.address,
        db_user: var.db_username,
        db_password: var.db_passwd,
        db_name: var.db_name
    })
}
