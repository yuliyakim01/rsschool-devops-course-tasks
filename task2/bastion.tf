resource "aws_instance" "bastion_host" {
    ami           = "ami-006d9dc984b8eb4b9"  
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.public_subnet_1.id
    key_name      = var.key_name

    vpc_security_group_ids = [aws_security_group.bastion_sg.id]  # Correct attribute for VPC

    tags = {
        Name = "bastion_host"
    }
}
