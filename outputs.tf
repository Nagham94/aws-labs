output "user_name" {
  description = "User name"
  value = module.iam.user_name
}

output "vpc_id" {
  description = "VPC id"
  value = module.vpc.vpc_id
}

output "ec2_pub_ip" {
  description = "ec2 public ip"
  value = module.ec2-ebs.ec2_pub_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

