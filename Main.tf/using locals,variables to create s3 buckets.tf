provider "aws" {
  region = "ap-south-1" #Mumbai region
  }

variable "bucket_names" {
  type = list(string)
  default = [ "logs", "backup", "data"]
}

locals {
   s3_bucket = { for name in var.bucket_names : name => "jenkins-${name}-bucket"}
}

resource "aws_s3_bucket" "my_bucket" {
  for_each = local.s3_bucket
  bucket = each.value  
}

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  # resource "aws_instance" "app-dev" {
  #   ami = "ami-0d682f26195e9ec0f"
  #   instance_type = "t2.micro"
  #   tags = local.common_tags
  # }

  # resource "aws_ebs_volume" "db_ebs" {
  #   availability_zone = "ap-south-1a"
  #   size = 8
  #   tags = {
  #     name = "testec2-volume"
  #   }
  # }
