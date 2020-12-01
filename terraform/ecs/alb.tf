
module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "~> 5.0"

    name = "${data.terraform_remote_state.vpc.outputs.project_name}-load-balancer"

    load_balancer_type = "application"

    vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
    subnets            = data.terraform_remote_state.vpc.outputs.public_subnets
    security_groups    = [ aws_security_group.lb.id ]

    target_groups = [
        {
            name_prefix      = "pref-"
            backend_protocol = "HTTP"
            backend_port     = 80
            target_type      = "ip"
        }
    ]

    http_tcp_listeners = [
        {
            port               = 80
            protocol           = "HTTP"
            target_group_index = 0
        }
    ]

    tags = {
        Environment = "Test"
    }
}


resource "aws_security_group" "lb" {
    name        = "${data.terraform_remote_state.vpc.outputs.project_name}-lb-security-group"
    description = "controls access to the ALB"
    vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id 

    ingress {
        protocol    = "tcp"
        from_port   = 0
        to_port     = "80"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}


