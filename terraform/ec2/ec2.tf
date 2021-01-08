resource "aws_instance" "srv" {
    count = length(var.instances)

    ami = var.ami_id
    instance_type = var.instances[count.index].instance_type
    subnet_id = local.subnet_ids[
        count.index % length(local.subnet_ids)
    ]
    key_name = var.key_pair
    vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
    associate_public_ip_address = var.instances[count.index].associate_public_ip_address

    tags = {
        Name = var.instances[count.index].name
    }

    user_data = join("\n", [
        file("docker_install.sh"),
        "sudo hostname ${var.instances[count.index].host_name}",
        var.instances[count.index].swarm_init
            ? "docker swarm init" : ""
    ])

}

data "aws_subnet_ids" "vpc" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

locals {
    subnet_ids = tolist(data.aws_subnet_ids.vpc.ids)
}

resource "aws_security_group" "ec2-sg" {
    name = "ec2-public-sg"
    description = "allow inbound access to the EC2 instance"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

    /* Highly careful firewall settings */

    ingress {
        description = "SSH"
        protocol    = "TCP"
        from_port   = 22
        to_port     = 22
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "HTTP"
        protocol    = "TCP"
        from_port   = 80
        to_port     = 80
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "HTTP"
        protocol    = "TCP"
        from_port   = 8080
        to_port     = 8080
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "HTTPS"
        protocol    = "TCP"
        from_port   = 443
        to_port     = 443
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "Redis"
        protocol    = "TCP"
        from_port   = 6379
        to_port     = 6379
        cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }

    ingress {
        description = "Docker swarm management"
        from_port   = 2377
        to_port     = 2377
        protocol    = "tcp"
        cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }

    ingress {
        description = "Docker container network discovery"
        from_port   = 7946
        to_port     = 7946
        protocol    = "tcp"
        cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }

    ingress {
        description = "Docker container network discovery"
        from_port   = 7946
        to_port     = 7946
        protocol    = "udp"
        cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }

    ingress {
        description = "Docker overlay network"
        from_port   = 4789
        to_port     = 4789
        protocol    = "udp"
        cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }

    egress {
        description = "Docker swarm (udp)"
        from_port   = 0
        to_port     = 0
        protocol    = "udp"
        cidr_blocks = [ data.terraform_remote_state.vpc.outputs.vpc_cidr ]
    }


    /* */

    /* Highly permissive firewall settings
    
    ingress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    */
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
