output "instance_id" {
  value = aws_instance.my_ubuntu_web.id
}


output "webserver_public_ip_adress" {
  value = aws_instance.my_ubuntu_web.public_ip
}

output "webserver_private_ip_adress" {
  value = aws_instance.my_ubuntu_web.private_ip
}

output "instance_state" {
  value = aws_instance.my_ubuntu_web.instance_state
  
}

output "security_group_id" {
  value = aws_security_group.my_webserver.id
  description = "This is SecurityGroup ID"
}