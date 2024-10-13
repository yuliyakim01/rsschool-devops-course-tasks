terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws",
            version = "~> 5.69.0"
        }
    }

    backend "s3" {
        bucket         = "terraform-states-bucket-yuliyakim"
        key            = "terraform-state"
        region         = "ap-south-1"
        encrypt        = true
        dynamodb_table = "terraform-lock-table"
    }
}