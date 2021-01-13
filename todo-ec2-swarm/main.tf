provider "aws" {
    profile = data.terraform_remote_state.vpc.outputs.aws_profile
    region = data.terraform_remote_state.vpc.outputs.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../terraform/state/vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "rds" {
  backend = "local"
  config = {
    path = "../terraform/state/db/terraform.tfstate"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "local"
  config = {
    path = "../terraform/state/ec2/terraform.tfstate"
  }
}

locals {
    srv-addresses = data.terraform_remote_state.ec2.outputs.srv-addresses
    srv-hostnm = data.terraform_remote_state.ec2.outputs.srv-hostnm

    lb_domains = [
            var.todo_domain, "www.${var.todo_domain}",
            var.dbadmin_domain, "www.${var.dbadmin_domain}",
            var.mgr_domain ]
}

data "aws_route53_zone" "rootzone" {
    name         = "${var.rootzone_name}."
    private_zone = false
}

resource "aws_route53_record" "lb_dns" {
    count = length(local.lb_domains)
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "${local.lb_domains[count.index]}."
    type    = "A"
    ttl     = "60"
    records = local.srv-addresses
}

resource "aws_route53_record" "srv" {
    count = length(local.srv-addresses)

    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "${local.srv-hostnm[count.index]}.${var.base_name}"
    type    = "A"
    ttl     = "60"
    records = [ local.srv-addresses[count.index] ]
}

resource "local_file" "stack-deploy" {
    filename = "${path.module}/deploy.sh"
    content = templatefile("./tmpl/deploy-tmpl.sh", {
        domain_mgr: var.mgr_domain,
        domain_todo: var.todo_domain,
        domain_todo_www: "www.${var.todo_domain}"
        domain_dbadmin: var.dbadmin_domain,
        domain_dbadmin_www: "www.${var.dbadmin_domain}"
        email_lets_encrypt: var.email_lets_encrypt,
        stack_name: var.stack_name
    })
}

resource "local_file" "stack-down" {
    filename = "${path.module}/down.sh"
    content = templatefile("./tmpl/down-tmpl.sh", {
        stack_name: var.stack_name
    })
}

resource "local_file" "stack-status" {
    filename = "${path.module}/status.sh"
    content = templatefile("./tmpl/status-tmpl.sh", {
        stack_name: var.stack_name
    })
}

