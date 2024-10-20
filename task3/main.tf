# main.tf

provider "aws" {
  region = "ap-south-1"
}

# Create a VPC for the Kubernetes cluster
resource "aws_vpc" "kops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kOps VPC"
  }
}

# Create a public subnet for the cluster nodes
resource "aws_subnet" "kops_public_subnet" {
  vpc_id            = aws_vpc.kops_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "kOps Public Subnet"
  }
}

# Create a private subnet for the control plane and worker nodes
resource "aws_subnet" "kops_private_subnet" {
  vpc_id            = aws_vpc.kops_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "kOps Private Subnet"
  }
}


# Create an Internet Gateway
resource "aws_internet_gateway" "kops_igw" {
  vpc_id = aws_vpc.kops_vpc.id
}

# Create a route table for the public subnet
resource "aws_route_table" "kops_public_route" {
  vpc_id = aws_vpc.kops_vpc.id
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "kops_route_table_assoc" {
  subnet_id      = aws_subnet.kops_public_subnet.id
  route_table_id = aws_route_table.kops_public_route.id
}

# Create a route to the Internet Gateway
resource "aws_route" "kops_public_route_to_igw" {
  route_table_id         = aws_route_table.kops_public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kops_igw.id
}
