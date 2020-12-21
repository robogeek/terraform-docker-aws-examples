
data "aws_route53_zone" "rootzone" {
    name         = "${var.domain_root}."
    private_zone = false
}

locals {
    bare_domain = var.domain_root
    www_domain  = "www.${var.domain_root}"
    domain_names = [ "${local.bare_domain}.", "${local.www_domain}." ]
}

resource "aws_route53_record" "wordpress" {
    count   = length(local.domain_names)
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = local.domain_names[count.index]
    type    = "A"

    alias {
        name                   = module.alb.this_lb_dns_name
        zone_id                = module.alb.this_lb_zone_id
        evaluate_target_health = true
    }
}
