output "user_name" {
  description = "User name"
  value = module.iam.user_name
}

output "vpc_id" {
  description = "VPC id"
  value = module.vpc.vpc_id
}

