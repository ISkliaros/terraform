output "instance1_web" {
  value = aws_instance.amazon_linux_web.public_ip
}

output "instance2_jenkins_server" {
  value = aws_instance.amazon_linux_jenkins.public_ip
}

output "instance3_jenkins_slave1" {
  value = aws_instance.amazon_linux_slave.public_ip
}

