output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_id_2" {
  value = aws_subnet.public_subnet_2.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}