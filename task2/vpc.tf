resource "aws_vpc" "k8s_vpc" {
    cidr_block = var.vpc_cidr # defines the IP range for the VPC
    enable_dns_support = true # enabled for internal and external communication
    enable_dns_hostnames = true
    tags = {
        Name = "k8_vpc"
    }
}