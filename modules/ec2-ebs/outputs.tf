output "ec2_pub_ip" {
  value = aws_instance.web.public_ip
}

output "instance_id" {
  value = aws_instance.web.id
}

output "key_name" {
  value = aws_key_pair.my_key.key_name
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}