provider "aws" {
    profile   = var.aws_profile
    region    = var.aws_region
}

module "default-vpc" {
    source            = "../modules/default-vpc-data"
    default-vpc-name  = "default-vpc"
}

// Uncomment this if you desire to directly provision SSL certificates
/* module "acm" {
    source  = "terraform-aws-modules/acm/aws"
    version = "~> 2.0"

    domain_name = var.base_domain
    zone_id     = module.alb-dns.rootzone_id
    // This instead comes from module.alb-dns
    // zone_id     = data.aws_route53_zone.rootzone.zone_id

    subject_alternative_names = [ "www.${var.base_domain}" ]
} */

// Uncomment this to specify a certificate ARN in my.auto.tfvars
variable "ssl_cert_arn" { }

locals {
    // Uncomment this to specify a certificate ARN in my.auto.tfvars
    certificate_arn = var.ssl_cert_arn
    // Uncomment this if you desire to directly provision SSL certificates
    // certificate_arn = module.acm.this_acm_certificate_arn
    www_domain = "www.${var.base_domain}"
}

module "alb-dns" {
    source        = "../modules/alb-dns-names"
    project_name  = var.project_name
    vpc_id        = module.default-vpc.default_vpc_id
    vpc_subnets   = module.default-vpc.default_vpc_subnets
    rootzone_name = var.domain_root
    domain_names  = [ var.base_domain, local.www_domain ]
}

module "rds-instance" {
    source      = "../modules/rds"
    vpc_id      = module.default-vpc.default_vpc_id
    cidr = concat(module.default-vpc.default_vpc_cidrs, var.db_cidrs)
    publicly_accessible = var.db_public
    db_name     = var.db_name
    db_username = var.db_username
    db_passwd   = var.db_passwd
}

resource "local_file" "deploy" {
    filename = "${path.module}/deploy.sh"
    content = templatefile("./tmpl/deploy-tmpl.sh", {
        alb_arn: module.alb-dns.alb_arn,
        certificate_arn: local.certificate_arn,
        // certificate_arn: module.acm.this_acm_certificate_arn,
        sequelize_connect_arn: aws_secretsmanager_secret.todo-access.arn,
        www_domain: local.www_domain,
        base_domain: var.base_domain
    })
}

resource "local_file" "convert" {
    filename = "${path.module}/convert.sh"
    content = templatefile("./tmpl/convert-tmpl.sh", {
        alb_arn: module.alb-dns.alb_arn,
        certificate_arn: local.certificate_arn,
        // certificate_arn: module.acm.this_acm_certificate_arn,
        sequelize_connect_arn: aws_secretsmanager_secret.todo-access.arn,
        www_domain: local.www_domain,
        base_domain: var.base_domain
    })
}
