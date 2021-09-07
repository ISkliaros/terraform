#---------------------------------------------------------------
# Provision Higly Availeble Web in any Region Default VPC
# Create:
#   - Security Group for Web Server
#   - Launch Configuration with Auto AMI Lookup
#   - Auto Scaling using 2 Availabilyty Zone
#   - Classic Load Balancer in 2 Avaliabilyty Zone
# 
# Made by Serhii Skliarov 06-September-2021
#---------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available"{}

data "aws_ami" "latest_amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

#---------------------------------------------------------------

resource "aws_security_group" "dynamic_secgroup" {
  name        = "Dynamic Securuty Group"
  description = "Allow inbound traffic ports: 22, 80, 443 etc"
  
    dynamic "ingress"{
      for_each = ["80", "443"]
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
  
  tags = {
    Name = "Dynamic Security Group"
    Owner = "Serhii Skliarov"
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix   = "WebServer-Higly-Avaliable-LC"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  security_groups = ["aws_security_group.dynamic_secgroup.id"]
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = "WebServer-Higly-Avaliable-ASG"
  launch_configuration = aws_launch_configuration.web.name
  min_size = 2
  max_size = 2
  min_elb_capacity = 2 
  health_check_type = "ELB"
  load_balancers = [aws_elb.web.name]
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id ]

  dynamic "tag"{
    for_each = {
        Name = "Web-in-ASG"
        Owner = "Serhii Skliarov"
    }
    content{
        key = tag.key
        value = tag.value
        propagate_at_launch = true
    }
  }

    lifecycle {
    create_before_destroy = true
  }  
}

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = ["data.aws_availability_zones.available.names[0]", "data.aws_availability_zones.available.names[1]"]
  security_groups = [ "aws_security_group.web.id" ]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }

  tags = {
    Name = "WebServer-Higly-Avaliable-ELB"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "data.aws_availability_zones.available.names[0]"
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "data.aws_availability_zones.available.names[1]"
}

#---------------------------------------------------------
output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}