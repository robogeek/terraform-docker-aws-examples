variable "ami_id" {
    // Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - in us-west-2 
    // default = "ami-0d1cd67c26f5fca19"
    // Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - in us-west-2
    default = "ami-09dd2e08d601bff67"
}

variable "instance_type"  { default = "t2.micro" }
variable "key_pair"       { default = "notes-app-key-pair" }

variable "configuration" {
    type = map(list(object({
        name = string,
        instance_type = string,
        associate_public_ip_address = bool,
        host_name = string,
        ssh_connect = string,
        swarm_init = bool
    })))
    default = {
        "DEV" = [
            {
                name = "ec2-srv1",
                instance_type = "t2.micro",
                associate_public_ip_address = true,
                host_name = "srv1",
                ssh_connect = "srv1",
                swarm_init = true
            },
            {
                name = "ec2-srv2",
                instance_type = "t2.micro",
                associate_public_ip_address = true,
                host_name = "srv2",
                ssh_connect = "srv2",
                swarm_init = false
            },
            {
                name = "ec2-srv3",
                instance_type = "t2.micro",
                associate_public_ip_address = true,
                host_name = "srv3",
                ssh_connect = "srv3",
                swarm_init = false
            }
        ]
        // ...
    }
}
