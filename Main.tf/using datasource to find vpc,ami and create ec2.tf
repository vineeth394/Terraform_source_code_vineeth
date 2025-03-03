provider "aws" {
 region = var.default_region
}
variable "default_region" {
 default = "ap-south-1"
 description = "The default region"
}
variable "instance_name"{
 default = "Server"
 description = "This is the name of the server"
}
variable "inst_type" {
 default = "t2.micro"
 description = "This is the type of the instance"
}
locals {
 common_tags = {
 "name" = "vineeth-instance"
 "team" = "Dev-ops"
 "role" = "Devops-Engineer"
 "creation_date" = "date-${formatdate("DDMMYYYY", timestamp())}"
 #"Name" = element(["Devops", "developer", "Dev-sec-ops"], 1)
 "Name" = "${var.instance_name}-ec2-${var.inst_type}-${substr(timestamp(), 0, 10)}"
}
}
resource "aws_instance" "Locale_testing" {
 instance_type = var.inst_type
 tags = local.common_tags
 
 
 ami = data.aws_ami.pull_ami.id
 
}
data "aws_ami" "pull_ami" {
 most_recent = true
 owners = ["amazon"]
 filter {
 name = "name"
 values = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
 filter {
 name = "root-device-type"
 values = ["ebs"]
 }
 filter {
 name = "virtualization-type"
 values = ["hvm"]
 }
 
}
output "ami" {
 value = data.aws_ami.pull_ami.id
}
data "aws_vpc" "pull_vpc" {
 default = true
}
output "VPC" {
 value = data.aws_vpc.pull_vpc.id
}