variable "aws_profile"  { default = "notes-app" }
variable "aws_region"   { default = "us-west-2" }

variable "project_name" { default = "example" }

variable "enable_dns_support"     { default = true }
variable "enable_dns_hostnames"   { default = true }
variable "enable_nat_gateway"     { default = true }
variable "single_nat_gateway"     { default = false }
variable "one_nat_gateway_per_az" { default = false }
variable "create_igw"             { default = true }

variable "vpc_cidr"      { default = "10.0.0.0/16" }
variable "public_subnet_cidrs" {
    default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ] 
}
