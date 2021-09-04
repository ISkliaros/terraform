#--------------------------------------
# My Terraform
#
# Build WebSerwer during Bootstrap
# Made by Serhii Skliarov
#--------------------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "my_ubuntu" {
  count = "1"
/*   name = "WebServer UserData" */
  tags = {
    name = "My_Ubuntu_WebServer"
    owner = "SSkliarov"
  }
  ami = "ami-0ec23856b3bad62d3"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name = "skl_rsa"
  security_groups = [ "sg_open_traffic" ]
  user_data = templatefile("inst_centos.tpl", {
    f_name = "Serhii",
    l_name = "Skliarov",
    names = ["Mike", "Peter", "Denis", "Joe", "Will"]
  })
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Securuty Group"
  description = "Allow inbound traffic ports: 22, 80, 443"
#  vpc_id      = aws_vpc.main.id

    ingress {
      description      = "WebServer Securuty Group"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
      description      = "WebServer Securuty Group"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
      description      = "WebServer Securuty Group"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    egress{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  

/*   ingress = [
      {
      description      = "WebServer Securuty Group"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "WebServer Securuty Group"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = "WebServer Securuty Group"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ] */

/*   egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ] */

  tags = {
    Name = "Allow ports :22, :80, :443"
    Owner = "Serhii Skliarov"
  }
}