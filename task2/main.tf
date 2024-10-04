# main.tf contains VPC, subnets, internet gateway, and route tables

provider "aws"{
    region = var.region
}

resource "aws_vpc" "k8_vpc" {
    cidr_block = var.vpc_cidr # defines the IP range for the VPC
    enable_dns_support = true # enabled for internal and external communication
    enable_dns_hostnames = true
    tags = {
        Name = "k8_vpc"
    }
}

# creating public subnet 1
resource "aws_subnet" "public_subnet_1" {
    # tells terraform to place subnet within a specific VPC, referencing the ID of the VPS created earlier
    vpc_id = aws.vpc.k8s_vpc.id 

    # specifies IP address for subnet using CIDR
    cidr_block = var.public_subnet_cidr_1

    # availability zone, data center in specified AWS region
    availability_zone = "ap-south-1a" 

    # tells AWS to automatically assign a public IP address to any instance that's launched in this subnet
    map_public_ip_on_launch = true

    # tags are key-value paits used to organize and manage AWS resources
    # tagging subnet with the name "public_subnet_1" for easier identification in AWS console
    tags = {
        Name = "public_subnet_1"
    }
}

# creating public subnet 2
resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws.vpc.k8s_vpc.id 

    # IP range is different from first subnet
    cidr_block = var.public_subnet_cidr_2 
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet_2"
    }
}

# creating private subnet 1
resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws.vpc.k8s_vpc.id
    cidr_block = var.private_subnet_cidr_1 
    availability_zone = "ap-south-1c"
    tags = {
        Name = "private_subnet_1"
    }
}

# creating private subnet 2
resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws.vpc.k8s_vpc.id
    cidr_block = var.private_subnet_cidr_2 
    availability_zone = "ap-south-1d"
    tags = {
        Name = "private_subnet_2"
    }
}

# creating the Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws.vpc.k8s_vpc.id
    tags = {
        Name = "k8s_internet_gateway"
    }
}

# setting up route for public subnets
resource "aws_route_table" "public_route" {
    vpc_id = aws.vpc.k8s_vpc.id
    tags = {
        Name = "public_route"
    }
}

# associate the public subnets with route table
resource "aws_route_table_association" "public_route_assoc_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "public_route_assoc_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route.id
}

# add route to the internet 
resource "aws_route" "internet_access" {
    route_table_id = aws_route_table.public_route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}
