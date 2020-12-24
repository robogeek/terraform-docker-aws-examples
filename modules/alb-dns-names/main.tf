
///////////- INPUT VARIABLES

variable "project_name"  { }
variable "vpc_id"        { }
variable "vpc_subnets"   { }
variable "rootzone_name" { }
variable "domain_names"  { }

///////////- MAIN CODE

module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "~> 5.0"

    name = "${var.project_name}-load-balancer"

    load_balancer_type = "application"

    vpc_id             = var.vpc_id
    subnets            = var.vpc_subnets
    security_groups    = [ aws_security_group.lb.id ]
}

resource "aws_security_group" "lb" {
    name        = "${var.project_name}-lb-security-group"
    description = "controls access to the ALB"
    vpc_id      = var.vpc_id

    ingress {
        protocol    = "tcp"
        from_port   = 0
        to_port     = "80"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        protocol    = "tcp"
        from_port   = 0
        to_port     = "443"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

data "aws_route53_zone" "rootzone" {
    name         = "${var.rootzone_name}."
    private_zone = false
}

resource "aws_route53_record" "wordpress" {
    count   = length(var.domain_names)
    zone_id = data.aws_route53_zone.rootzone.zone_id
    name    = "${var.domain_names[count.index]}."
    type    = "A"

    alias {
        name                   = module.alb.this_lb_dns_name
        zone_id                = module.alb.this_lb_zone_id
        evaluate_target_health = true
    }
}

///////////- OUTPUT VALUES

output "alb_dns"      { value = module.alb.this_lb_dns_name }
output "alb_arn"      { value = module.alb.this_lb_arn }
output "alb_id"       { value = module.alb.this_lb_id }
