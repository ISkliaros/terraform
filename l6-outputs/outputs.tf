output "instance_id" {
  value = aws_instance.my_ubuntu.id
}


output "webserver_public_ip_adress" {
  value = aws_instance.my_ubuntu.public_ip
}

output "webserver_private_ip_adress" {
  value = aws_instance.my_ubuntu.private_ip
}

output "instance_state" {
  value = aws_instance.my_ubuntu.instance_state
  
}

output "security_group_id" {
  value = aws_security_group.my_webserver.id
  description = "This is SecurityGroup ID"
}