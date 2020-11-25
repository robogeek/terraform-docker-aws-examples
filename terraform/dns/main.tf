provider "aws" {
  profile = data.terraform_remote_state.vpc.outputs.aws_profile
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

terraform {
  backend "local" {
    path = "../state/dns/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../state/vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "local"
  config = {
    path = "../state/ec2/terraform.tfstate"
  }
}

locals {
    srv-addresses = data.terraform_remote_state.ec2.outputs.srv-addresses
    srv-hostnm = data.terraform_remote_state.ec2.outputs.srv-hostnm
}

data "aws_route53_zone" "rootzone" {
    name         = "reikiworld.biz."
    private_zone = false
}

resource "aws_route53_record" "todo" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = data.aws_route53_zone.rootzone.name
    type    = "A"
    ttl     = "60"
    records = local.srv-addresses
}

resource "aws_route53_record" "todo-www" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "www.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = local.srv-addresses
}

resource "aws_route53_record" "mgr" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "mgr.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = local.srv-addresses
}

resource "aws_route53_record" "mgr-www" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "www.mgr.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = local.srv-addresses
}

resource "aws_route53_record" "srv" {
    count = length(local.srv-addresses)

    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "${local.srv-hostnm[count.index]}.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = [ local.srv-addresses[count.index] ]
}

output "todo-ips" { value = aws_route53_record.todo.records }
output "todo-dns" { value = aws_route53_record.todo.fqdn    }

output "todo-www-ips" { value = aws_route53_record.todo-www.records }
output "todo-www-dns" { value = aws_route53_record.todo-www.fqdn    }

output "mgr-ips" { value = aws_route53_record.mgr.records }
output "mgr-dns" { value = aws_route53_record.mgr.fqdn    }

output "mgr-www-ips" { value = aws_route53_record.mgr-www.records }
output "mgr-www-dns" { value = aws_route53_record.mgr-www.fqdn    }

output "servers-ips" { value = aws_route53_record.srv.*.records   }
output "servers-dns" { value = aws_route53_record.srv.*.fqdn      }
