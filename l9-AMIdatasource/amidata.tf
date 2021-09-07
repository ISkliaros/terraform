#--------------------------------------
# My Terraform
# #
# Find latest AMI id of:
#   Ubuntu 18.04
#   Amazon Linux 2
#   Windows Server 2016 Base
#
# Made by Serhii Skliarov
#--------------------------------------

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ubumtu_latest" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
}

data "aws_ami" "latest_ubuntu" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_ami" "latest_ws2016" {
  most_recent      = true
  owners           = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }
}

output "latest_amazon_Windows_Server2016_id" {
    value = data.aws_ami.latest_ws2016.id
}

output "latest_amazon_Windows_Server2016_name" {
    value = data.aws_ami.latest_ws2016.name
}

output "latest_amazon_linux_id" {
    value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_name" {
    value = data.aws_ami.latest_amazon_linux.name
}

output "latest_ubuntu_ima_id" {
    value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ima_name" {
    value = data.aws_ami.latest_ubuntu.name
}