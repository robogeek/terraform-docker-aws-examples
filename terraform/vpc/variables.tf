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

/* variable "configuration" {
    type = map(object({
        vpc_cidr=string,
        public_subnet_cidrs=list(string),
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
            enable_nat_gateway = true,
            single_nat_gateway = false,
            one_nat_gateway_per_az = false,
            create_igw = true,
            enable_dns_support = true,
            enable_dns_hostnames = true
        },
        "QA" = {
            vpc_cidr = "10.1.0.0/16",
            public_subnet_cidrs = [ "10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24" ],
            enable_nat_gateway = true,
            single_nat_gateway = false,
            one_nat_gateway_per_az = false,
            create_igw = true,
            enable_dns_support = true,
            enable_dns_hostnames = true
        },
        "STAGE" = {
            vpc_cidr = "10.2.0.0/16",
            public_subnet_cidrs = [ "10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24" ],
            enable_nat_gateway = true,
            single_nat_gateway = false,
            one_nat_gateway_per_az = false,
            create_igw = true,
            enable_dns_support = true,
            enable_dns_hostnames = true
        },
        "PROD" = {
            vpc_cidr = "10.3.0.0/16",
            public_subnet_cidrs = [ "10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24" ],
            enable_nat_gateway = true,
            single_nat_gateway = false,
            one_nat_gateway_per_az = false,
            create_igw = true,
            enable_dns_support = true,
            enable_dns_hostnames = true
        }
    }
} */
