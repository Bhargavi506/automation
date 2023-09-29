provider "aws" {
    region = "us-east-1"
    #access_key =""
    #secret_key = ""
}
# create s3 bucket
resource "aws_s3_bucket" "terraform-backend-s3-bucket-12345" {
  bucket = "terraform-backend-s3-bucket-12345" # Replace with your desired bucket name
  acl    = "private"               # You can configure the access control list (ACL) as needed

  lifecycle {
    prevent_destroy =true  # if anyone try to delete means it gives error.
  }
  versioning {
    enabled = true
  }
  server_uside_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm= "AES256"
      }
    }
  }
  tags = {
    Name        = "terraform-backend-s3-bucket-12345"
  }
}

