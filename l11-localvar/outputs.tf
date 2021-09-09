output "instance1_ip" {
  value = aws_instance.amazon_linux[0].public_ip
}

output "instance2_ip" {
  value = aws_instance.amazon_linux[1].public_ip
}

output "instance3_ip" {
  value = aws_instance.amazon_linux[2].public_ip
}

