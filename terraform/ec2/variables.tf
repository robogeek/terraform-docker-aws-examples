variable "ami_id" {
    // Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - in us-west-2 
    // default = "ami-0d1cd67c26f5fca19"
    // Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - in us-west-2
    default = "ami-09dd2e08d601bff67"
}

variable "instance_type" { default = "t2.micro" }
variable "key_pair"      { default = "notes-app-key-pair" }
