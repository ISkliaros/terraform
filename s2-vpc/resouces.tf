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

#----------------Create ec2 resources-------------------------

 resource "aws_instance" "amazon_linux_web" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.dev_public_a.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_apache.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Server Admin"})
}

resource "aws_instance" "amazon_linux_jenkins" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.dynamic_secgroup.id]
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.dev_public_a.id
  monitoring = var.enable_dital_monitoring
  user_data = "${file("install_slave.sh")}"
  tags = merge(var.common_tag, {Name = "${var.common_tag["Environment"]} Jenkins Worker"})
}

/*
resource "aws_instance" "amazon_linux_slave" {
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