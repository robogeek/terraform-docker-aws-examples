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

data "aws_route53_zone" "rootzone" {
    name         = "reikiworld.biz."
    private_zone = false
}

resource "aws_route53_record" "todo" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = data.aws_route53_zone.rootzone.name
    type    = "A"
    ttl     = "60"
    records = [ data.terraform_remote_state.ec2.outputs.ec2-srv1-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv2-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv3-ip ]
}

resource "aws_route53_record" "todo-www" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "www.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = [ data.terraform_remote_state.ec2.outputs.ec2-srv1-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv2-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv3-ip ]
}

resource "aws_route53_record" "mgr" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "mgr.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = [ data.terraform_remote_state.ec2.outputs.ec2-srv1-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv2-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv3-ip ]
}

resource "aws_route53_record" "mgr-www" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "www.mgr.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = [ data.terraform_remote_state.ec2.outputs.ec2-srv1-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv2-ip,
                data.terraform_remote_state.ec2.outputs.ec2-srv3-ip ]
}

resource "aws_route53_record" "srv1" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "srv1.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = [ data.terraform_remote_state.ec2.outputs.ec2-srv1-ip ]
}

resource "aws_route53_record" "srv2" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "srv2.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = [ data.terraform_remote_state.ec2.outputs.ec2-srv2-ip ]
}

resource "aws_route53_record" "srv3" {
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "srv3.${data.aws_route53_zone.rootzone.name}"
    type    = "A"
    ttl     = "60"
    records = [ data.terraform_remote_state.ec2.outputs.ec2-srv3-ip ]
}

