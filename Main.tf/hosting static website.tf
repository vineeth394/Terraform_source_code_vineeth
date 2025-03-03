provider "aws" {
    region     = "ap-south-1"
}

resource "aws_security_group" "devsecops" {
  name = "devsecops"
  description = "Access ssh and http"
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
   ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
}

resource "aws_instance" "wp-instance" {
  ami           = "ami-00bb6a80f01f03502"
  instance_type = "t2.micro"
  key_name = "terraform_ec2_key"
  security_groups = ["${aws_security_group.devsecops.name}"]
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2 wget unzip
    sudo systemctl start apache2
    sudo systemctl enable apache2
    cd /tmp
    wget https://www.free-css.com/assets/files/free-css-templates/download/page292/logistica.zip
    unzip logistica.zip

     sudo mv shipping-company-website-template/* /var/www/html/
     sudo systemctl restart apache2

  EOF
  tags = {
    Name = "Webpage_hosting"
  }
}

resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "terraform_ec2_key"
  public_key = "${file("terraform_ec2_key.pub")}"
}