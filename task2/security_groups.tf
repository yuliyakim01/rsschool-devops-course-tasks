
resource "aws_security_group" "bastion_sg" {
    vpc_id = aws_vpc.k8s_vpc.id
    name = "bastion_sg"

    # allow inbound SSH from anywhere
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # allow outbound traffic to any IP
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bastion_sg"
    }
}

