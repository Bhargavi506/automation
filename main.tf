provider "aws" {
    region = "us-east-1"
    access_key ="AKIASYBPATUCUXQLCI7X"
    secret_key = "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"
}

# create custom VPC
resource "aws_vpc" "core" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cluster_vpc"
  }
}

resource "aws_vpc" "ran" {
  cidr_block = "11.0.0.0/16"

  tags = {
    Name = "cluster_vpc"
  }
}

resource "aws_vpc" "monitoring" {
  cidr_block = "13.0.0.0/16"

  tags = {
    Name = "cluster_vpc"
  }
}
