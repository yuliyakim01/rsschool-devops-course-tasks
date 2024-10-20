Kubernetes Cluster Setup Using kOps on AWS - README
Overview
This README documents the process of setting up a Kubernetes cluster on AWS using kOps. The cluster was deployed using Terraform to manage AWS infrastructure and kOps to handle Kubernetes cluster deployment. During the process, several errors were encountered, and they are documented along with the steps taken to troubleshoot and resolve them.

Prerequisites
AWS CLI installed and configured with access to create EC2 instances, VPCs, and other necessary resources.
Terraform installed to manage AWS infrastructure.
kOps installed to handle Kubernetes cluster deployment.
kubectl installed for managing Kubernetes resources.
A domain name for cluster DNS or use of a .local domain for testing purposes.
SSH key to connect to EC2 instances (bastion host and control plane).
1. Terraform Code for AWS Resources
The initial step was to create the necessary AWS resources (VPC, subnets, bastion host, and security groups) using Terraform. Three Terraform files were created to keep the infrastructure organized:

main.tf
Contains the main VPC, subnets, and route tables.

bastion.tf
Contains the EC2 instance for the bastion host.

Security Group Configuration: Encountered an issue where security groups were not associated with the correct VPC. Error message: "You have specified two resources that belong to different networks."
Solution: Adjusted the Terraform code to ensure that all resources were within the correct VPC.
2. Cluster Deployment Using kOps
Cluster Creation Using kOps
The next step was deploying the Kubernetes cluster using kOps.

bash
Copy code
kops create cluster \
  --name=yuliyas-cluster.local \
  --zones=ap-south-1a,ap-south-1b \
  --node-count=2 \
  --node-size=t3.micro \
  --control-plane-size=t3.micro \
  --network-id=vpc-09e4925c56bbeaf28 \
  --subnets=subnet-037c72c718b5464bd,subnet-06aac2fe257f9290f \
  --topology private \
  --bastion
Issues Encountered:
API Server Timeout: After the cluster creation, kubectl was unable to connect to the API server. Error message: "dial tcp <API-IP>:443: connect: connection refused."

Solution: Checked security groups, verified inbound rules for port 443, and verified load balancer health. Unfortunately, the API server was unreachable, and further troubleshooting was needed.
kOps Validation Failure: The kops validate cluster command failed with the following error: "validation failed: cannot load kubecfg settings."

Solution: Attempted to re-export kubeconfig, but API access issues persisted.
3. Cluster Verification
The next task was to verify the cluster using the command:

bash
Copy code
kubectl get nodes
Issues Encountered:
Authentication Issues: kubectl kept asking for a username and password. Error message: "Please enter Username."
Solution: Attempted to modify the kubeconfig file to include basic authentication, but issues persisted with API server access.
4. Workload Deployment
The workload deployment was supposed to be completed using the following command:

kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml

Issues Encountered:
Unable to deploy the workload due to failure to connect to the Kubernetes API server.
5. Additional Tasks: Monitoring
The plan was to implement monitoring using Prometheus and Grafana. However, due to the API server access issues, this task was not completed.

Summary of Issues and Troubleshooting
Terraform Resource Errors: Fixed security group associations within the correct VPC.
Cluster Validation Failure: The kops validate cluster command failed due to API connection issues.
API Server Unreachable: The Kubernetes API server was unreachable on port 443, causing kubectl commands to fail.
Authentication Issues: kubectl prompted for a username and password due to kubeconfig misconfiguration, but the issue persisted after multiple attempts to fix the kubeconfig.
Workload Deployment Incomplete: Unable to deploy the workload due to API connection issues.
Conclusion
Although the cluster creation using kOps completed successfully, issues related to API server connectivity and authentication prevented full verification and workload deployment. The infrastructure was properly configured using Terraform, and the steps taken have been documented, along with the errors encountered along the way.