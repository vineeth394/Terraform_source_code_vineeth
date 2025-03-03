provider "aws" {
  region = "ap-south-1"  #Mumbai region
}

locals {
  time = "date-${formatdate("DDMMYYYY", timestamp())}"
}

variable "region" {
  default = "ap-south-1"
}

variable "tags" {
  type = list
  default = ["firstec2","secondec2"]
} 

variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-04b4f1a9cf54c11d0"
    "ap-south-1" = "ami-0d682f26195e9ec0f"
  }
}

resource "aws_key_pair" "loginkey" {
key_name = "terraform_ec2_key"
public_key = file("${path.module}/terraform_ec2_key.pub")
}

# lookup(map,key,default)
resource "aws_instance" "app_dev" {
  ami = lookup(var.ami,var.region)
  instance_type = "t2.micro"
  key_name = aws_key_pair.loginkey.key_name
  count = 2

  tags = {
    name = element(var.tags,count.index)
  }
}