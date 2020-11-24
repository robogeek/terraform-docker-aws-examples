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

locals {
    env_name = data.terraform_remote_state.vpc.outputs.env_name
    config = var.configuration[data.terraform_remote_state.vpc.outputs.env_name]
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
    subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-security-group"
  description = "allow inbound access to the database"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 3306
    // cidr_blocks = [ "0.0.0.0/0" ]
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
  allocated_storage    = local.config.allocated_storage
  storage_type         = local.config.storage_type
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = local.config.instance_class
  identifier           = local.config.tododb_id
  name                 = local.config.tododb_name
  username             = local.config.tododb_username
  password             = local.config.tododb_userpasswd
  parameter_group_name = aws_db_parameter_group.default.id
  db_subnet_group_name = aws_db_subnet_group.default.id
  vpc_security_group_ids = [ aws_security_group.rds-sg.id ]
  publicly_accessible  = false
  skip_final_snapshot  = local.config.skip_final_snapshot
  multi_az             = local.config.multi_az
}
