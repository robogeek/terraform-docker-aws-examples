variable "tododb_id"         { default = "tododb" }
variable "tododb_name"       { default = "todo" }
variable "tododb_username"   { default = "todo" }
variable "tododb_userpasswd" { default = "passw0rd" }
variable "tododb_port"       { default = "3306" }

variable "allocated_storage" { default = 20 }
variable "storage_type"      { default = "gp2" }
variable "instance_class"    { default = "db.t2.micro" }
variable "skip_final_snapshot" { default = true }
variable "multi_az"          { default = true }
variable "publicly_accessible" { default = false }

variable "ingress_extra_cidrs" { default = [] }
variable "egress_extra_cidrs" { default = [] }
