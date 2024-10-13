

# associate the public subnets with route table
resource "aws_route_table_association" "public_route_assoc_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "public_route_assoc_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route.id
}

# public subnet routing
resource "aws_route" "internet_access" {
    route_table_id = aws_route_table.public_route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

# private route table
resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.k8s_vpc.id 

    tags = {
        Name = "private_route_table"
    }
}

# associate the private route table with the private subnet
resource "aws_route_table_association" "private_subnet_assoc" {
    subnet_id      = aws_subnet.private_subnet_1.id 
    route_table_id = aws_route_table.private_route.id
}

