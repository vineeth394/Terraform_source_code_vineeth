# Specify the AWS provider and region
provider "aws" {
  region = var.aws_region
}


# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr


  tags = {
    Name = "MyVPC"
  }
}


# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true  # This enables public IP for instances


  tags = {
    Name = "PublicSubnet"
  }
}


# Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr


  tags = {
    Name = "PrivateSubnet"
  }
}


# Create Security Group
resource "aws_security_group" "allow_ssh_https" {
  vpc_id = aws_vpc.my_vpc.id


  # Allow SSH (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }


  # Allow HTTPS (Port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.https_ingress_cidr]
  }


  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "AllowSSHAndHTTPS"
  }
}


# Launch EC2 Instance in Public Subnet
resource "aws_instance" "my_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_https.id]


  tags = {
    Name = "MyEC2Instance"
  }
}