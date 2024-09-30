terraform {
  backend "s3" {
    bucket         = "terraform-states-bucket-yuliyakim"
    key            = "task1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "GitHubActionsPolicy"
  description = "Policy for GitHub Actions to manage Terraform resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",  # Grant access to S3 bucket
          "ec2:*", # Grant access to EC2 actions (if necessary)
          "iam:*"  # Grant access to IAM actions (if necessary)
        ]
        resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  policy_arn = aws_iam_policy.github_actions_policy.arn
  role       = aws_iam_role.github_actions_role.name
}
