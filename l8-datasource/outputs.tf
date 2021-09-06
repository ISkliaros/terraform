output "data_prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "data_prod_vpc_cidr_block" {
  value = data.aws_vpc.prod_vpc.cidr_block
}

output "data_account_id" {
  value = data.aws_caller_identity.current.user_id
}

output "data_aws_availability_zone_working" {
  value = data.aws_availability_zones.working.names[0]
}

output "data_current_aws_region" {
  value = data.aws_region.current.name
}

output "data_current_aws_region_description" {
  value = data.aws_region.current.description
}

/* output "data_my_current_vpcs" {
  value = data.aws_vpcs.my_current_vpcs.ids
} */
####################################
output "aws_subnet_prod_subnet_1" {
  value = aws_subnet.prod_subnet_1.id
}

output "aws_subnet_prod_subnet_1_cider_block" {
  value = aws_subnet.prod_subnet_1.cidr_block
}

output "aws_subnet_prod_subnet_2" {
  value = aws_subnet.prod_subnet_2.id
}

output "aws_subnet_prod_subnet_2_cidr_block" {
  value = aws_subnet.prod_subnet_2.cidr_block
}