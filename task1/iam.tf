data "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsRole"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${data.aws_iam_openid_connect_provider.github.arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub": "repo:yuliyakim01/https://github.com/yuliyakim01/rsschool-devops-course-tasks.git:ref:refs/heads/task1"
          }
        }
      }
    ]
  }
  EOF
}


resource "aws_iam_policy" "github_actions_policy" {
  name        = "GitHubActionsPolicy"
  description = "Policy for GitHub Actions to manage Terraform resources"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:*",
          "route53:*",
          "s3:*",
          "iam:*",
          "vpc:*",
          "sqs:*",
          "events:*"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ],
        "Resource": "arn:aws:dynamodb:ap-south-1:396608786836:table/terraform-lock-table"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  policy_arn = aws_iam_policy.github_actions_policy.arn
  role       = aws_iam_role.github_actions_role.name
}
