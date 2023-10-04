provider "aws" {
    region = "us-east-1"
    #access_key =""
    
}
# create s3 bucket
resource "aws_s3_bucket" "terraform_state_s3" {
  #make sure you give unique bucket name
  bucket = "terraform-state-s3-111" 
  force_destroy = true
# Enable versioning to see full revision history of our state files
  versioning {
         enabled = true
        }

# Enable server-side encryption by default
server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# 2 - this Creates Dynamo Table
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
        attribute {
         name = "LockID"
         type = "S"
      }
}
# giving backend state file management with s3
terraform {
  backend "s3" {
    #Replace this with your bucket name!
    bucket         = "terraform-state-s3-111"
    key            = "dc/s3/terraform.tfstate"
    region         = "us-east-1"
    #Replace this with your DynamoDB table name!
    dynamodb_table = "tf-locks"
    encrypt        = true
    }
}
# create custom VPC
resource "aws_vpc" "core_vpc" {
  cidr_block = "190.1.0.0/16"

  tags = {
    Name = "core_vpc"
  }
}

# create core subnet
resource "aws_subnet" "core_subnet" {
  vpc_id            = aws_vpc.core_vpc.id
  cidr_block        = "190.1.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "core_subnet"
  }
}

# create Internet gateway for core vpc
resource "aws_internet_gateway" "core_IGW" {
    depends_on = [ aws_vpc.core_vpc ]
    vpc_id = aws_vpc.core_vpc.id

    tags = {
        Name = "core_IGW"
    }
}

# create public route table for core
resource "aws_route_table" "core_rt" {
    vpc_id = "${aws_vpc.core_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.core_IGW.id}"
    }

    tags = {
        Name = "core_rt"
    }
}

# public route table association for core vpc
resource "aws_route_table_association" "public_ass" {
    # The subnet ID to create an association.
    subnet_id = aws_subnet.core_subnet.id

    # The ID of the routing table to associate with.
    route_table_id = aws_route_table.core_rt.id
}

#################   ran VPC  ###############

resource "aws_vpc" "ran_vpc" {
  cidr_block = "190.2.0.0/16"

  tags = {
    Name = "ran_vpc"
  }
}

# create ran subnet
resource "aws_subnet" "ran_subnet" {
  vpc_id            = aws_vpc.ran_vpc.id
  cidr_block        = "190.2.0.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ran_subnet"
  }
}

# create Internet gateway for ran vpc
resource "aws_internet_gateway" "ran_IGW" {
    depends_on = [ aws_vpc.ran_vpc ]
    vpc_id = aws_vpc.ran_vpc.id

    tags = {
        Name = "ran_IGW"
    }
}

# create public route table for ran
resource "aws_route_table" "ran_rt" {
    vpc_id = "${aws_vpc.ran_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.ran_IGW.id}"
    }

    tags = {
        Name = "ran_rt"
    }
}

# public route table association for ran vpc
resource "aws_route_table_association" "ran_ass" {
    # The subnet ID to create an association.
    subnet_id = aws_subnet.ran_subnet.id

    # The ID of the routing table to associate with.
    route_table_id = aws_route_table.ran_rt.id
}

############    Monitoing VPC  ############

resource "aws_vpc" "monitoring_vpc" {
  cidr_block = "190.3.0.0/16"

  tags = {
    Name = "monitoring_vpc"
  }
}

# create monitoring subnet
resource "aws_subnet" "monitoring_subnet" {
  vpc_id            = aws_vpc.monitoring_vpc.id
  cidr_block        = "190.3.0.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "monitoring_subnet"
  }
}

# create Internet gateway for monitoring vpc
resource "aws_internet_gateway" "monitoring_IGW" {
    depends_on = [ aws_vpc.monitoring_vpc ]
    vpc_id = aws_vpc.monitoring_vpc.id

    tags = {
        Name = "monitoring_IGW"
    }
}

# create public route table for monitoring
resource "aws_route_table" "monitoring_rt" {
    vpc_id = "${aws_vpc.monitoring_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.monitoring_IGW.id}"
    }

    tags = {
        Name = "monitoring_rt"
    }
}

# public route table association for core vpc
resource "aws_route_table_association" "monitoring_ass" {
    # The subnet ID to create an association.
    subnet_id = aws_subnet.monitoring_subnet.id

    # The ID of the routing table to associate with.
    route_table_id = aws_route_table.monitoring_rt.id
}