provider "aws" {
    region = "us-east-1"
    #access_key =""
    #secret_key = ""
}
# create s3 bucket
resource "aws_s3_bucket" "terraform-backend-s3-bucket-12345" {
  bucket = "terraform-backend-s3-bucket-12345" # Replace with your desired bucket name
  acl    = "public"               # You can configure the access control list (ACL) as needed

  tags = {
    Name        = "terraform-backend-s3-bucket-12345"
  }
}

