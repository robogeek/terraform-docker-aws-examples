resource "aws_db_instance" "kanboard" {
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t2.micro"
    name                 = var.db_name
    username             = var.db_username
    password             = var.db_passwd
    parameter_group_name = aws_db_parameter_group.default.id
    publicly_accessible  = true
    skip_final_snapshot  = true
}

resource "aws_db_parameter_group" "default" {
    name   = "rds-pg"
    family = "mysql8.0"

    parameter {
        name  = "character_set_server"
        value = "utf8"
    }

    parameter {
        name  = "character_set_client"
        value = "utf8"
    }
}
