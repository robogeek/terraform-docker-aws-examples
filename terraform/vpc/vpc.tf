resource "aws_vpc" "example" {
    cidr_block       = local.config.vpc_cidr
    enable_dns_support = local.config.enable_dns_support
    enable_dns_hostnames = local.config.enable_dns_hostnames

    tags = {
        Name = "${var.project_name}-${var.env_name}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.example.id

    tags = {
        Name =  "${var.project_name}-IGW"
    }
}

resource "aws_route" "route-public" {
    route_table_id         = aws_vpc.example.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public" {
    count = length(local.config.public_subnet_cidrs)

    vpc_id     = aws_vpc.example.id
    cidr_block = local.config.public_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[
        count.index % length(data.aws_availability_zones.available.names)
    ]

    tags = {
        Name = "${var.project_name}-public-${count.index}"
    }
}

resource "aws_route_table_association" "public" {
    count = length(local.config.public_subnet_cidrs)
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_vpc.example.main_route_table_id
}

resource "aws_subnet" "private" {
    count = length(local.config.private_subnet_cidrs)

    vpc_id     = aws_vpc.example.id
    cidr_block = local.config.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[
        count.index % length(data.aws_availability_zones.available.names)
    ]

    tags = {
        Name = "${var.project_name}-private-${count.index}"
    }
}

resource "aws_eip" "gw" {
    vpc        = true
    depends_on = [ aws_internet_gateway.igw ]

    tags = {
        Name =  "${var.project_name}-EIP"
    }
}

resource "aws_nat_gateway" "gw" {
    subnet_id     = aws_subnet.public[0].id
    allocation_id = aws_eip.gw.id

    tags = {
        Name =  "${var.project_name}-NAT"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.example.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gw.id
    }

    tags = {
        Name =  "${var.project_name}-rt-private"
    }
}

resource "aws_route_table_association" "private" {
    count = length(local.config.private_subnet_cidrs)
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}
