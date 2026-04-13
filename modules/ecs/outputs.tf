output "ecs_instance_public_ip" {
  value = aws_instance.ecs_instance.public_ip
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}