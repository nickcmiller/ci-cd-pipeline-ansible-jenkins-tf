data "aws_availability_zones" "available" {}

resource "random_id" "random" {
    byte_length = 3
}

resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = {
        Name = "main_vpc-${random_id.random.dec}"
    }
    
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_internet_gateway" "main_internet_gateway" {
    vpc_id = aws_vpc.main_vpc.id
    
    tags = {
        Name = "main-igw-${random_id.random.dec}"
    }
}

resource "aws_route_table" "main_route_table" {
    vpc_id = aws_vpc.main_vpc.id
    
    tags = {
        Name = "Main Public"
    }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.main_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_internet_gateway.id
}

resource "aws_default_route_table" "private_route_table" {
    default_route_table_id = aws_vpc.main_vpc.default_route_table_id
    
    tags = {
        Name = "Main Private"
    }
}

resource "aws_subnet" "main_public_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_cidrs
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]
    
    tags = {
        Name = "main-public"
    }
}