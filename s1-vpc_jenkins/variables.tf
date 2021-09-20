variable "region" {
    description = "Please set region for you AWS infrastructure"
    default = "eu-west-1"
}

variable "vpc_cidr_block" {
    description = "Please set VPC cidr_block"
    default = "10.0.0.0/16"
}

variable "dev_subnet1_cidr_block" {
    description = "Please set dev_subnet_1 cidr_block"
    default = "10.0.10.0/24"
}

variable "dev_subnet2_cidr_block" {
    description = "Please set dev_subnet_2 cidr_block"
    default = "10.0.20.0/24"
}

variable "instance_type" {
    description = "Please set instance type"
    default = "t2.micro"
}

variable "count_instances" {
  default = "2"
}

variable "key_name" {
    description = "Please set key name"
    default = "skl_rsa"
}

variable "allow_ports" {
    description = "Please enter allowed ports"
    type = list
    default = ["22", "443", "80"]
}

variable "enable_dital_monitoring" {
    description = "Allow monitoring: true/false"
    type = bool
    default = false
}

variable "common_tag" {
    description = "Common tag add to all resources"
    type = map
    default = {
        Owner = "Serhii Skliarov"
        Project = "Ansible"
        Environment = "Dev"
    }
  
}