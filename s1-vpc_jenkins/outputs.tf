output "instance1_ip" {
  value = aws_instance.amazon_linux_web.public_ip
}

output "instance2_ip" {
  value = aws_instance.amazon_linux_slave.public_ip
}

/* output "instance3_ip" {
  value = aws_instance.amazon_linux[2].public_ip
} */

