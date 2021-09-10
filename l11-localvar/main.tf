#---------------------------------------------------------------
# Work with Terraform variables
# Create:
#   - local file with variables
# 
# Made by Serhii Skliarov 08-September-2021
#---------------------------------------------------------------

provider "aws" {
  region = var.region 
}

data "aws_ami" "latest_amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_elb" "name" {
  name = "WebELB"
  availability_zones = data.aws_availability_zones.available.names

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.amazon_linux[0].id, aws_instance.amazon_linux[1].id, aws_instance.amazon_linux[2].id] 
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "web-elb"
  }

}

resource "aws_instance" "amazon_linux" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  count = var.count_instances
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = var.key_name
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_apache.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Server WEB"})
}

resource "aws_security_group" "dynamic_secgroup" {
  name        = "Dynamic Securuty Group"
  description = "Allow inbound traffic ports: 22, 80, 443 etc"
  
    dynamic "ingress"{
      for_each = var.allow_ports
      content{
        from_port        = ingress.value
        to_port          = ingress.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
      }
    }

    egress{
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = merge(var.common_tag, {Name = "Dynamic Security Group"})
}