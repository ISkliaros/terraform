provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "my_Ubuntu" {
  count = "1"
  tags = {
    name = "My_Ubuntu_Server"
    owner = "SSkliarov"
  }
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "skl_rsa"
  security_groups = [ "sg_open_traffic" ]
}