terraform {
    backend "s3" {
        bucket = "terraform-states-bucket-yuliyakim"
        key = "task1/terraform.tfstate"
        region = "ap-south-1"
        dynamodb_table = "terraform-lock-table"
    }
}