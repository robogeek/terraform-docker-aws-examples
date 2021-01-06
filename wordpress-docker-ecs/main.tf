provider "aws" {
    profile   = var.aws_profile
    region    = var.aws_region
}

module "default-vpc" {
    source            = "../modules/default-vpc-data"
    default-vpc-name  = "default-vpc"
}

module "alb-dns" {
    source        = "../modules/alb-dns-names"
    project_name  = var.project_name
    vpc_id        = module.default-vpc.default_vpc_id
    vpc_subnets   = module.default-vpc.default_vpc_subnets
    rootzone_name = var.domain_root
    domain_names  = [ var.domain_root, "www.${var.domain_root}" ]
}

module "rds-instance" {
    source      = "../modules/rds"
    vpc_id      = module.default-vpc.default_vpc_id
    // Use this to restrict access to the VPC network
    // cidr        = module.default-vpc.default_vpc_cidrs
    // Use this for permissive access by anyone
    cidr = concat(module.default-vpc.default_vpc_cidrs, [ "0.0.0.0/0" ])
    // Use this to make the database publicly accessible
    publicly_accessible = true
    db_name     = var.db_name
    db_username = var.db_username
    db_passwd   = var.db_passwd
}

/* locals {
  default-vpc-id      = module.default-vpc.default_vpc_id
  default-vpc-subnets = module.default-vpc.default_vpc_subnets
  default-vpc-cidrs   = module.default-vpc.default_vpc_cidrs
} */
