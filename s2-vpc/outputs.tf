# Output data
output "vpc-dev-ID" {
    value = "${aws_vpc.dev_vpc.id}"
}
