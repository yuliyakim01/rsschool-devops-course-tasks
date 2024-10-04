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