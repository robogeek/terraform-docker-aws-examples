
variable "aws_profile"  {  }
variable "aws_region"   {  }

variable "project_name" { default = "todo-ecs" }

variable "db_name"      { default = "todo" }
variable "db_username"  { default = "t0d0" }
variable "db_passwd"    { default = "passw0rd" }

variable "domain_root"  { }

variable "cidrs"        { }
