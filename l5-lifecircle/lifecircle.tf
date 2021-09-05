#--------------------------------------
# My Terraform
#
# Build WebSerwer during Bootstrap
# Made by Serhii Skliarov
#--------------------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_eip" "my_static_ip" {
#  instance = aws_instance.my_ubuntu[count.0]
  instance = aws_instance.my_ubuntu.id
}

resource "aws_instance" "my_ubuntu" {
#  count = "1"
  tags = {
    name = "My_Ubuntu_WebServer"
    owner = "SSkliarov"
  }
  ami = "ami-0ec23856b3bad62d3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name = "skl_rsa"
  security_groups = [ "sg_open_traffic" ]
  user_data = templatefile("inst_centos.tpl", {
    f_name = "Serhii",
    l_name = "Skliarov",
    names = ["Mike", "Peter", "Denis"]
  })

  lifecycle {
#    prevent_destroy = true  # Prevent destroy of the server
#    prevent_changes = ["ami", "user_data"]  # Prevent changes in some parameters
    create_before_destroy = true
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
      from_port        = 443
      to_port          = 443
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