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

data "aws_vpc" "selected" {
    id = data.terraform_remote_state.vpc.outputs.vpc_id
}

data "aws_subnet_ids" "vpc" {
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

locals {
    subnet_ids = tolist(data.aws_subnet_ids.vpc.ids)
}

resource "aws_db_subnet_group" "default" {
    name       = "main"
    subnet_ids = local.subnet_ids
}

resource "aws_security_group" "rds-sg" {
    name        = "rds-security-group"
    description = "allow inbound access to the database"
    vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

    ingress {
        protocol    = "tcp"
        from_port   = 0
        to_port     = 3306
        // cidr_blocks = [ data.aws_vpc.selected.cidr_block ]
        cidr_blocks = concat([ data.aws_vpc.selected.cidr_block ], var.ingress_extra_cidrs)
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        // cidr_blocks = [ data.aws_vpc.selected.cidr_block ]
        cidr_blocks = concat([ data.aws_vpc.selected.cidr_block ], var.egress_extra_cidrs)
    }
}

resource "aws_db_instance" "tododb" {
    allocated_storage    = var.allocated_storage
    storage_type         = var.storage_type
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = var.instance_class
    identifier           = var.tododb_id
    name                 = var.tododb_name
    username             = var.tododb_username
    password             = var.tododb_userpasswd
    parameter_group_name = aws_db_parameter_group.default.id
    db_subnet_group_name = aws_db_subnet_group.default.id
    vpc_security_group_ids = [ aws_security_group.rds-sg.id ]
    publicly_accessible  = var.publicly_accessible
    skip_final_snapshot  = var.skip_final_snapshot
    multi_az             = var.multi_az
}
