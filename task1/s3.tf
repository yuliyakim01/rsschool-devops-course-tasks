resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = var.bucket_name
  versioning {
    enabled = true
  }

  tags = {
    Name = "Yuliya's Terraform State Bucket"
    Environment = "Dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

