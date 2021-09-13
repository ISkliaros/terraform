#---------------------------------------------------------------
# Creating Dev infrustructure in any Region Default VPC
# Create:
#   - Security Group for Servers
#   - Launch ec2 instances
#   - 
#   - 
# 
# Made by Serhii Skliarov 13-September-2021
#------------------------------------------------------------

provider "aws" {
  region = var.region 
}


#------------------Data sources------------------------------

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

#-------------Dynamic Securuty Group-----------------------

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

#----------------Create ec2 resources-------------------------

resource "aws_instance" "amazon_linux_web" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
#  count = var.count_instances
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = var.key_name
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_apache.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Server WEB"})
}

resource "aws_instance" "amazon_linux_slave" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
#  count = var.count_instances
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = var.key_name
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_slave.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Jenkins slave/node"})
}



#------------------------------------------------------------
#------------------------------------------------------------