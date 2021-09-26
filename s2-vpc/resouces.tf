#---------------------------------------------------------------
# Creating Dev infrustructure in any Region Default VPC
# Create:
#   - Search AMI
#   - Launch ec2 instances
#   - Add key pairs
#   - 
# 
# Made by Serhii Skliarov 20-September-2021

#------------------Data sources AMI---------------------------
data "aws_ami" "latest_amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3hHnCryj4aVbiRspBTMTVR8D9trreJF3uK0cmIW1Fcas0Zb+WOb4IBaHcBMbQWw5c8Rsl3kc5cz/sASrwrDzZ18grloMjGkp7qqfMbYB02ZZCFelh4O0nMoi2B2XlT4QjsC92BfAFnxxrzDzcHAIpdXYYwiPl99T4DpykNdc5aRFqjYnsk/bONiv08hh0GsP8qjl0l+RyDu2s71pFOHIcO9idqdqF6ZjkkwqTgmsPjIrvHc+zJ+AnraDPOho/XUH617PdThspWSQBMu4EuMxxJTRPgSomHMIYCCxLmAeW1RmSTow0DRLgUS6E3nkx18DKmtdR2t2QGZq4CFnKrjvp4Crj7I/B7i2F8gVgihvehsQFAi1sL53Fc+0d4lRrAYtPXocLLX6y8rusgVEloySCrlFhIU4oui8ZaIIWwny9r7grssfTTZqacXSIKV7ou5Mq5jdVgNKGNN0Hk77r1VUly1OmNI29YOooYxx+TT0yIdkaDrrolVkBF8ulfUOzhAGZsgsxMhGmaMpaMNJSC4qLW3CV4gOLhIHwt2kamywTMOny4VYTacpIAQvOH74GN829pNHx7FNn+rg0ql76u/xTh6tE/3oWH34lLrTNBNsJaIP7UaIoTjwSAjJRiRCmaI3JisZlBWgx0EWq/BmQ4EomwKkFHR4Yc1+JOJVzT6hSoQ=="
}

#----------------Create ec2 resources-------------------------

resource "aws_instance" "amazon_linux_web" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.dev_public_a.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_apache.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Server WEB"})
}

resource "aws_instance" "amazon_linux_jenkins" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.dev_public_a.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_slave.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Jenkins server"})
}

/* resource "aws_instance" "amazon_linux_slave" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.dev_public_a.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_slave.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Jenkins slave/node"})
} */

#------------------------------------------------------------