### Output data

output "vpc-dev-ID" {
    value = "${aws_vpc.dev_vpc.id}"
}

output "instance1_admin" {
  value = aws_instance.amazon_linux_web.public_ip
}

output "instance2_worker" {
  value = aws_instance.amazon_linux_jenkins.public_ip
}

/* output "instance3_jenkins_slave1" {
  value = aws_instance.amazon_linux_slave.public_ip
}
 */