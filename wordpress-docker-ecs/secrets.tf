variable "secret-name" {
    default = "wpdb-access"
}

resource "aws_secretsmanager_secret" "wpdb-access" {
    name = var.secret-name
}

resource "aws_secretsmanager_secret_version" "wpdb-access" {
    secret_id     = aws_secretsmanager_secret.wpdb-access.id
    secret_string = jsonencode({
        db_host:     module.rds-instance.dns_name,
        db_user:     var.db_username,
        db_password: var.db_passwd,
        db_name:     var.db_name
    })
}
