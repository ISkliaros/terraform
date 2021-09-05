#--------------------------------------
# My Terraform
#
# Build WebSerwer during Bootstrap
# Made by Serhii Skliarov
#--------------------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "my_ubuntu_web" {
  ami = "ami-0ec23856b3bad62d3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name = "skl_rsa"
  tags = {
    Name = "My_Ubuntu_WebServer"
    owner = "SSkliarov"
  }
  depends_on = [aws_instance.my_ubuntu_db, aws_instance.my_ubuntu_app]
}

resource "aws_instance" "my_ubuntu_app" {
  ami = "ami-0ec23856b3bad62d3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name = "skl_rsa"
  tags = {
    Name = "My_Ubuntu_AppServer"
    owner = "SSkliarov"
  }
  depends_on = [
    aws_instance.my_ubuntu_db
  ]
}

resource "aws_instance" "my_ubuntu_db" {
  ami = "ami-0ec23856b3bad62d3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name = "skl_rsa"
  tags = {
    Name = "My_Ubuntu_DatabaseServer"
    owner = "SSkliarov"
  }

}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Securuty Group"
  description = "Allow inbound traffic ports: 22, 80, 443"

    dynamic "ingress" {
      for_each = ["80", "443"]
      content {
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
      }
    }

    ingress {
      description      = "Securuty Group SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["176.36.236.149/32"]
    }

    egress{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name = "Allow ports :22, :80, :443"
    Owner = "Serhii Skliarov"
  }
}