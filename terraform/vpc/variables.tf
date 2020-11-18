variable "aws_profile"  { default = "notes-app" }
variable "aws_region"   { default = "us-west-2" }

variable "project_name" { default = "example" }

variable "enable_dns_support"   { default = true }
variable "enable_dns_hostnames" { default = true }

variable "vpc_cidr"      { default = "10.0.0.0/16" }
variable "public1_cidr"  { default = "10.0.1.0/24" }
variable "public2_cidr"  { default = "10.0.2.0/24" }
variable "public3_cidr"  { default = "10.0.3.0/24" }