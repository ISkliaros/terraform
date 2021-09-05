#--------------------------------------
# My Terraform
#
# Dynamic block of code
#
# Made by Serhii Skliarov
#--------------------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "my_webserver" {
  name        = "Dynamic Securuty Group"
  description = "Allow inbound traffic ports: 22, 80, 443"
  
    dynamic "ingress"{
      for_each = ["80", "443", "8080", "1541", "9092", "9093"]
      content{
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
      }
    }

    ingress {
      description      = "WebServer Securuty Group SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["176.36.236.149/32", ]
    }

    egress{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name = "Dynamic Security Group"
    Owner = "Serhii Skliarov"
  }
}