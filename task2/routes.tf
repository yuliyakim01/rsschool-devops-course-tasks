

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