
module "acm" {
    source  = "terraform-aws-modules/acm/aws"
    version = "~> 2.0"

    domain_name = var.bare_domain
    zone_id     = data.aws_route53_zone.rootzone.zone_id

    subject_alternative_names = [ local.www_domain ]
}

module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "~> 5.0"

    name = "${local.vpc-outputs.project_name}-load-balancer"

    load_balancer_type = "application"

    vpc_id             = local.vpc-outputs.vpc_id
    subnets            = local.vpc-outputs.public_subnets
    security_groups    = [ aws_security_group.lb.id ]

    # Use HTTP for communication with the back-end container
    target_groups = [ {
        name_prefix      = "pref-"
        backend_protocol = "HTTP"
        backend_port     = 80
        target_type      = "ip"
    } ]

    # For any HTTP inbound traffic, redirect to HTTPS
    http_tcp_listeners = [ {
        port        = 80
        protocol    = "HTTP"
        action_type = "redirect"
        redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    } ]

    # For any HTTPS inbound traffic, use the certificate provisioned above,
    # and send to target group
    # The behavior is modified by the rules below
    https_listeners = [ {
        port               = 443
        protocol           = "HTTPS"
        certificate_arn    = module.acm.this_acm_certificate_arn

        # This provides a default action for any traffic that does not
        # match the rules below.  The rules below match the domain names
        # we've assigned to the application.  Any traffic not matching
        # the rules is therefore for something else, and is a mistake.
        action_type = "fixed-response"
        fixed_response = {
            content_type = "text/plain"
            message_body = "BAD DOMAIN NAME"
            status_code  = "200"
        }
    } ]

    https_listener_rules = [
        # For traffic arriving on the bare domain,
        # send to the target group
        {
            https_listener_index = 0

            actions = [ {
                type               = "forward"
                target_group_index = 0
            } ]

            conditions = [ {
                host_headers = [ var.bare_domain ]
            } ]
        },
        # For traffic arriving on the WWW domain,
        # redirect to the bare domain
        {
            https_listener_index = 0

            actions = [ {
                type        = "redirect"
                status_code = "HTTP_301"
                host        = var.bare_domain
                protocol    = "HTTPS"
            } ]

            conditions = [ {
                host_headers = [ local.www_domain ]
            } ]
        }
    ]
}

resource "aws_security_group" "lb" {
    name        = "${local.vpc-outputs.project_name}-lb-security-group"
    description = "controls access to the ALB"
    vpc_id      = local.vpc-outputs.vpc_id 

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


