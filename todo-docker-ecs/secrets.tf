variable "secret-name" {
    default = "todo-access"
}

resource "aws_secretsmanager_secret" "todo-access" {
    name = var.secret-name
}

resource "aws_secretsmanager_secret_version" "todo-access" {
    secret_id     = aws_secretsmanager_secret.todo-access.id
    /*
    dbname: todo 
    username: todo
    password: todo12345
    params: 
        host: localhost
        port: 3306
        dialect: mysql
    */
    secret_string = yamlencode({
        dbname: var.db_name,
        username: var.db_username,
        password: var.db_passwd,
        params: {
            host: module.rds-instance.dns_name,
            port: "3306",
            dialect: "mysql"
        }
    })
}
