provider "aws" {
    region = "eu-west-1"
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
/* data "aws_vpcs" "my_current_vpcs" {} */

# Exercise: Create subnet in VPC

data "aws_vpc" "prod_vpc" {
  tags = {
    "Name" = "prod"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block = "10.20.1.0/24"
  tags = {
    "Name" = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    "Account" = "Subnet Account ID: ${data.aws_caller_identity.current.user_id}"
    "Region" = "${data.aws_region.current.name}"
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block = "10.20.2.0/24"
  tags = {
    "Name" = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    "Account" = "Subnet Account ID: ${data.aws_caller_identity.current.user_id}"
    "Region" = "${data.aws_region.current.name}"
  }
}
