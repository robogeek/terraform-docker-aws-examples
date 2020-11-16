provider "aws" {
  profile = data.terraform_remote_state.vpc.outputs.aws_profile
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

terraform {
  backend "local" {
    path = "../state/db/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../state/vpc/terraform.tfstate"
  }
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

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [
        data.terraform_remote_state.vpc.outputs.subnet_public1_id,
        data.terraform_remote_state.vpc.outputs.subnet_public2_id ]
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-security-group"
  description = "allow inbound access to the database"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 3306
    cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
  }
}

resource "aws_db_instance" "tododb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  identifier           = var.tododb_id
  name                 = var.tododb_name
  username             = var.tododb_username
  password             = var.tododb_userpasswd
  parameter_group_name = aws_db_parameter_group.default.id
  db_subnet_group_name = aws_db_subnet_group.default.id
  vpc_security_group_ids = [ aws_security_group.rds-sg.id ]
  publicly_accessible  = false
  skip_final_snapshot  = true
  multi_az             = true
}
