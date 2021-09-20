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

data "aws_region" "current" {}
data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "latest_amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
#----------------- Create subnet in VPC ----------------------

resource "aws_vpc" "dev_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

#------------------- Internet Gateway  -----------------------

resource "aws_internet_gateway" "dev_gw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-gw"
  }
}

#----------------- Create subnet in VPC ----------------------

resource "aws_subnet" "dev_subnet_1" {
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block = var.dev_subnet1_cidr_block
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    "Account" = "Subnet Account ID: ${data.aws_caller_identity.current.user_id}"
    "Region" = "${data.aws_region.current.name}"
  }
}

resource "aws_subnet" "dev_subnet_2" {
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block = var.dev_subnet2_cidr_block
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    "Account" = "Subnet Account ID: ${data.aws_caller_identity.current.user_id}"
    "Region" = "${data.aws_region.current.name}"
  }
}

#-------------Dynamic Securuty Group-------------------------

resource "aws_security_group" "dynamic_secgroup" {
  name        = "Dynamic Securuty Group"
  description = "Allow inbound traffic ports: 22, 80, 443 etc"
  vpc_id      = aws_vpc.dev_vpc.id
  
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
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = var.key_name
  subnet_id = aws_subnet.dev_subnet_1.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_apache.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Server WEB"})
}

resource "aws_instance" "amazon_linux_jenkins" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = var.key_name
  subnet_id = aws_subnet.dev_subnet_1.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_slave.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Jenkins server"})
}
resource "aws_instance" "amazon_linux_slave" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = var.key_name
  subnet_id = aws_subnet.dev_subnet_1.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_slave.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Jenkins slave/node"})
}

#------------------------------------------------------------