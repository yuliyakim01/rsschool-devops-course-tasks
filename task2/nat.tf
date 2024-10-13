# elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet_1.id
    tags = {
        Name = "nat_gateway"
    }
}

# route table entry for private subnet to route traffic through NAT gateway
resource "aws_route" "private_route_to_nat" {
    route_table_id         = aws_route_table.private_route.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat_gw.id
    depends_on = [aws_nat_gateway.nat_gw]
}
