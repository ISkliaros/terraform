#---------------------------------------------------------------
# Creating Dev infrustructure in any Region Default VPC
# Create:
#   - VPC
#   - Subnets
#   - Securuty Group
#   - 
# 
# Made by Serhii Skliarov 20-September-2021
#------------------------------------------------------------

provider "aws" {
  region = var.region 
}

#------------------Data sources------------------------------
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "working" {}

#----------------- Create subnet in VPC ----------------------

resource "aws_vpc" "dev_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  enable_dns_hostnames = false
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

#------------------- Internet Gateway  -----------------------

resource "aws_internet_gateway" "dev_gw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "${var.vpc_name} IGW"
  }
}

#----------------- Create subnet in VPC ----------------------

resource "aws_subnet" "dev_public_a" {
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block = var.dev_subnet1_cidr_block
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "Public-A env:  ${var.vpc_name}"
    "Account" = "Subnet Account ID: ${data.aws_caller_identity.current.user_id}"
    "Region" = "${data.aws_availability_zones.working.names[0]}"
  }
}

resource "aws_subnet" "dev_public_b" {
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block = var.dev_subnet2_cidr_block
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "Public-B env:  ${var.vpc_name}"
    "Account" = "Subnet Account ID: ${data.aws_caller_identity.current.user_id}"
    "Region" = "${data.aws_availability_zones.working.names[0]}"
  }
}

#------------------ Create route tables -----------------------

resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.dev_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =aws_internet_gateway.dev_gw.id
  }

  tags = {
    Name = "${var.vpc_name} route table"
  }
}

#--------------- Association route for dev ----------------------

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev_public_a.id
  route_table_id = aws_default_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.dev_public_b.id
  route_table_id = aws_default_route_table.public.id
}

#---------------  Deffault DHCP Option Set  ----------------------

resource "aws_default_vpc_dhcp_options" "default" {
  tags = {
    Name = "Default DHCP Option Set"
  }
}

#-------------- Default VPC Network ACL --------------------------

resource "aws_default_network_acl" "default" {
    default_network_acl_id = aws_vpc.dev_vpc.default_network_acl_id
    egress {
        protocol = "-1"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }

    subnet_ids = [
        "${aws_subnet.dev_public_a.id}",
        "${aws_subnet.dev_public_b.id}"
    ]
    
    tags = {
    Name = "${var.vpc_name} ACLs"
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

#-------------Default Securuty Group-------------------------

resource "aws_security_group" "default-security-gp" {
    name = "Allow-all"
    vpc_id = aws_vpc.dev_vpc.id
    description = "Allow all inbound traffic"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.common_tag, {Name = "Defaul Security Group"})
}


