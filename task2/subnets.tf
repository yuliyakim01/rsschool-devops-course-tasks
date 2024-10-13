# creating public subnet 1
resource "aws_subnet" "public_subnet_1" {
    # tells terraform to place subnet within a specific VPC, referencing the ID of the VPS created earlier
    vpc_id = aws_vpc.k8s_vpc.id 

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
    vpc_id = aws_vpc.k8s_vpc.id

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
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = var.private_subnet_cidr_1 
    availability_zone = "ap-south-1a"
    tags = {
        Name = "private_subnet_1"
    }
}

# creating private subnet 2
resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = var.private_subnet_cidr_2 
    availability_zone = "ap-south-1b"
    tags = {
        Name = "private_subnet_2"
    }
}