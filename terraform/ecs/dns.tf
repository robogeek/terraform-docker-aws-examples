
data "aws_route53_zone" "rootzone" {
    name         = "${var.domain_root}."
    private_zone = false
}

locals {
    www_domain   = "www.${var.bare_domain}"
    domain_names = [ "${var.bare_domain}.", "${local.www_domain}." ]
}

resource "aws_route53_record" "todo" {
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
