
variable "ami_id" {
    // Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - in us-west-2 
    // default = "ami-0d1cd67c26f5fca19"
    // Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - in us-west-2
    default = "ami-09dd2e08d601bff67"
}
variable "instance_type" { default = "t2.micro" }
variable "key_pair"      { default = "example-key-pair" }
variable "ssh_cidrs"     { default = [ "0.0.0.0/0" ] }

resource "aws_instance" "ssh-srv" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = module.default-vpc.default_vpc_subnets[0]
    key_name = var.key_pair
    vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
    associate_public_ip_address = true

    tags = {
        Name = "ssh-srv"
    }

    user_data = file("efs-utils.sh")
}

resource "aws_security_group" "ec2-sg" {
    name = "ec2-public-sg"
    description = "allow inbound access to the EC2 instance"
    vpc_id = module.default-vpc.default_vpc_id

    ingress {
        description = "SSH"
        protocol    = "TCP"
        from_port   = 22
        to_port     = 22
        cidr_blocks = concat([ module.default-vpc.default_vpc_cidr ], var.ssh_cidrs) 
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_security_group" "allow-nfs" {
    name = "allow-nfs-sg"
    description = "allow NFS access"
    vpc_id = module.default-vpc.default_vpc_id

    ingress {
        description = "NFS"
        protocol    = "TCP"
        from_port   = 2049
        to_port     = 2049
        cidr_blocks = [ module.default-vpc.default_vpc_cidr ]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "ssh-srv-arn" { value = aws_instance.ssh-srv.arn }
output "ssh-srv-ip"  { value = aws_instance.ssh-srv.public_ip }
output "ssh-srv-dns" { value = aws_instance.ssh-srv.public_dns }
