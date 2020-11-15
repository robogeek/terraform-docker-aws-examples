resource "aws_instance" "srv1" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = data.terraform_remote_state.vpc.outputs.subnet_public1_id
    key_name = var.key_pair
    vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
    associate_public_ip_address = true 
    tags = {
        Name = "ec2-srv1"
    }
    // depends_on = [ 
    //     data.terraform_remote_state.vpc.outputs.vpc_id,
    //     data.terraform_remote_state.vpc.outputs.igw_id, ]
    user_data = join("\n", [
        file("docker_install.sh"),
        "sudo hostname srv1",
        "docker swarm init"
    ])
}

resource "aws_instance" "srv2" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = data.terraform_remote_state.vpc.outputs.subnet_public2_id
    key_name = var.key_pair
    vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
    associate_public_ip_address = true 
    tags = {
        Name = "ec2-srv2"
    }
    // depends_on = [ 
    //     data.terraform_remote_state.vpc.outputs.vpc_id,
    //     data.terraform_remote_state.vpc.outputs.igw_id ]
    user_data = join("\n", [
        file("docker_install.sh"),
        "sudo hostname srv2"
    ])
}

resource "aws_instance" "srv3" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = data.terraform_remote_state.vpc.outputs.subnet_public2_id
    key_name = var.key_pair
    vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
    associate_public_ip_address = true 
    tags = {
        Name = "ec2-srv3"
    }
    // depends_on = [ 
    //     data.terraform_remote_state.vpc.outputs.vpc_id,
    //     data.terraform_remote_state.vpc.outputs.igw_id ]
    user_data = join("\n", [
        file("docker_install.sh"),
        "sudo hostname srv3"
    ])
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
