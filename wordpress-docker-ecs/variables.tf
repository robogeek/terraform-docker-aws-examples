variable "aws_profile"  {  }
variable "aws_region"   {  }

variable "project_name" { default = "wp-ecs" }

variable "db_name"      { default = "wpdb" }
variable "db_username"  { default = "w0rdpress" }
variable "db_passwd"    { default = "passw0rd" }

variable "domain_root"  { }
