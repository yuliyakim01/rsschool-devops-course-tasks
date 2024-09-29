# rsschool-devops-course-tasks

## Overview
This repository contains the Terraform configuratin files for settingup an AWS infrastructure with GitHub Actions for deployment

It includes creating an S3 bucket for storing Terraform states and configuring an IAM role for GitHub Actions


## Prerequisites
Before you start, make sure you have:

- An active AWS account with administrative privileges (root account).
- Terraform installed (version 1.6 or higher).
- AWS CLI installed and configured.
- A GitHub account to set up GitHub Actions.

## Infrastructure set up

### 1. Clone the repository to your local machine:
git clone https://github.com/yuliyakim01/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks

### 2. Install dependencies:
Terraform, AWS CLI

### 3. Configure AWS CLI
configure your AWS CLI to use the IAM user's credentials
run: aws configure
AWS Access Key ID: [Your Access Key ID]
AWS Secret Access Key: [Your Secret Access Key]
Default region name: ap-south-1
Default output format: json

verify using: aws ec2 describe-instance-types --instance-types t4g.nano

### 4. Create Terraform State Bucket:
terraform {
    backend "s3" {
        bucket         = "terraform-states-bucket-yuliyakim"
        key            = "task1/terraform.tfstate"
        region         = "ap-south-1"
        dynamodb_table = "terraform-lock-table"
    }
}

### 5. Create IAM Role for GitHub Actions
Inside of terraformBucket.tf:

resource "aws_iam_policy" "github_actions_policy" {
  name        = "GitHubActionsPolicy"
  description = "Policy for GitHub Actions to manage Terraform resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",         # Grant access to S3 bucket
          "ec2:*",        # Grant access to EC2 actions (if necessary)
          "iam:*"         # Grant access to IAM actions (if necessary)
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  policy_arn = aws_iam_policy.github_actions_policy.arn
  role       = aws_iam_role.github_actions_role.name
}

### 6. Initialize and Apply Terraform:
terraform init
terraform plan
terraform apply

run in terminal of your directory

### 7. Configure GitHub Actions Workflow:
Inside of .github/workflows make a file called terraform-deployment.yml:

name: Terraform CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  terraform-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.6.0

      - name: Check Formatting
        run: terraform fmt -check

  terraform-plan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.6.0

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

  terraform-apply:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.6.0

      - name: Terraform Init
        run: terraform init

      - name: Terraform Apply
        run: terraform apply -auto-approve


