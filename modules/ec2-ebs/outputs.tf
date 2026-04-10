output "ec2_pub_ip" {
  value = aws_instance.web.public_ip
}