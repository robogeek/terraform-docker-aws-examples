
///////////- INPUT VARIABLES

variable "db_name"     { }
variable "db_username" { }
variable "db_passwd"   { }
variable "vpc_id"      { }
variable "cidr"        { }

variable "allocated_storage"   { default = 20 }
variable "storage_type"        { default = "gp2" }
variable "engine"              { default = "mysql" }
variable "engine_version"      { default = "8.0" }
variable "family"              { default = "mysql8.0" }
variable "instance_class"      { default = "db.t2.micro" }
variable "publicly_accessible" { default = false }
variable "skip_final_snapshot" { default = true }

///////////- MAIN CODE

resource "aws_db_instance" "this" {
    allocated_storage    = var.allocated_storage
    storage_type         = var.storage_type
    engine               = var.engine
    engine_version       = var.engine_version
    instance_class       = var.instance_class
    name                 = var.db_name
    username             = var.db_username
    password             = var.db_passwd
    parameter_group_name = aws_db_parameter_group.this.id
    vpc_security_group_ids = [ aws_security_group.this.id ]
    publicly_accessible  = var.publicly_accessible
    skip_final_snapshot  = var.skip_final_snapshot
}

resource "aws_db_parameter_group" "this" {
    family = var.family

    parameter {
        name  = "character_set_server"
        value = "utf8"
    }

    parameter {
        name  = "character_set_client"
        value = "utf8"
    }
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 3306
    cidr_blocks = var.cidr
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

///////////- OUTPUT VALUES

output "endpoint" { value = aws_db_instance.this.endpoint }
output "dns_name" { value = aws_db_instance.this.address }
output "port"     { value = aws_db_instance.this.port }
output "name"     { value = aws_db_instance.this.name }
output "arn"      { value = aws_db_instance.this.arn }
output "id"       { value = aws_db_instance.this.id }
