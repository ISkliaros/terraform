provider "aws" {
    region = "eu-west-1"
}

data "aws_availability_zones" "working" {}

output "data_aws_availability_zone_working" {
  value = data.aws_availability_zones.working.names
}