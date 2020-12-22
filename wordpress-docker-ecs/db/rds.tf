resource "aws_db_instance" "wordpress" {
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t2.micro"
    name                 = var.db_name
    username             = var.db_username
    password             = var.db_passwd
    parameter_group_name = aws_db_parameter_group.default.id
    vpc_security_group_ids = [ aws_security_group.rds-sg.id ]
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

resource "aws_security_group" "rds-sg" {
  name        = "rds-security-group"
  description = "allow inbound access to the database"
  vpc_id      = local.default-vpc-id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 3306
    // cidr_blocks = [ "0.0.0.0/0" ]
    cidr_blocks = local.default-vpc-cidrs
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
    // cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
  }
}
