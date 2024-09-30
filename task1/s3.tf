resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "terraform-states-bucket-yuliyakim"
  versioning {
    enabled = true
  }

  tags = {
    Name = "Yuliya's Terraform State Bucket"
    Environment = var.environment
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  
  lifecycle {
    prevent_destroy = true
  }
}

