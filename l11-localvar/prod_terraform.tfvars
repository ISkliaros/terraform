region = "eu-west-2"
instance_type = "t2.micro"
enable_dital_monitoring = false
count_instances = 2

allow_ports = ["22", "80"]

common_tag = {
    Owner = "Serhii Skliarov"
    Project = "Ansible"
    Environment = "Prod"
}