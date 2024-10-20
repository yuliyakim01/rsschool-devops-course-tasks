# Create a new bastion host in the new VPC
resource "aws_instance" "bastion" {
  ami           = "ami-006d9dc984b8eb4b9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.kops_public_subnet.id  # Place bastion in the new VPC's subnet
  key_name      = "my-key" 

  tags = {
    Name = "Bastion Host"
  }
}