variable "aws_profile"  { default = "notes-app" }
variable "aws_region"   { default = "us-west-2" }

variable "project_name" { default = "wp-ecs" }

variable "db_name"     { default = "wpdb" }
variable "db_username" { default = "w0rdpress" }
variable "db_passwd"   { default = "passw0rd" }

# Create an xyzzy.auto.tfvars file to override this
variable "domain_root" { default = "YOUR-DOMAIN.ORG" }
