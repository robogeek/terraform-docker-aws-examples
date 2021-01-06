variable "aws_profile"  { default = "notes-app" }
variable "aws_region"   { default = "us-west-2" }

variable "project_name" { default = "kanboard" }

variable "db_name"     { default = "kanboard" }
variable "db_username" { default = "kanboard" }
variable "db_passwd"   { default = "passw0rd" }

variable "enable_dns_support"   { default = true }
variable "enable_dns_hostnames" { default = true }

variable "env_name"     { default = "DEV" }

variable "configuration" {
    type = map(object({
        vpc_cidr=string,
        public_subnet_cidrs=list(string),
        private_subnet_cidrs=list(string),
        enable_nat_gateway=bool,
        single_nat_gateway=bool,
        one_nat_gateway_per_az=bool,
        create_igw=bool,
        enable_dns_support=bool,
        enable_dns_hostnames=bool
    }))
    default = {
        "DEV" = {
            vpc_cidr = "10.0.0.0/16",
            public_subnet_cidrs = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ],
            private_subnet_cidrs = [ "10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24" ],
            enable_nat_gateway = true,
            single_nat_gateway = false,
            one_nat_gateway_per_az = false,
            create_igw = true,
            enable_dns_support = true,
            enable_dns_hostnames = true
        },
    }
}
