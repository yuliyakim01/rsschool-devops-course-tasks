Kubernetes Networking Infrastructure Setup with Terraform: 
- creates basic infrastructure for a Kubernetes cluster on AWS using Terraform. This configuration includes a VPC, public and private subnets, an internet gateway, a NAT gateway and routing configurations to enable secure network communication.

Resources:

-- vpc.tf
Virtual Private Cloud, CIDR block 10.0.0.0/16

-- subnets.tf
2 public subnets in different Availability Zones (AZs) ap-south-1a & ap-south-1b
2 private subnets in different Availability Zones (AZs) ap-south-1a & ap-south-1b

-- igw.tf
Internet Gateway is properly created, associated with the VPC (aws_vpc.k8s_vpc.id), provides internet access to instances in public subnets

-- nat.tf
allows instances in private subnets to connect to the internet

-- main.tf
Provider and region stated

-- routes.tf
public subnets route traffic to the internet via Internet gateway, private subnets route traffic to the internet via NAT Gateway

--security_groups.tf
security groups for controlling inbound and outbound traffic to bastion host and other resources.

-- networkACLs.tf
fien-grained access control of traffic

-- bastion.tf
deployed in a public subnet for secure SSH access to instances in private subnets
