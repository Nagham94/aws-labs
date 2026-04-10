variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "Nagham"
}

variable "vpc_cidr" {
  description = "VPC cidr_block"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR (AZ 1)"
  type        = string
  default     = "192.168.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "Public subnet CIDR (AZ 2)"
  type        = string
  default     = "192.168.3.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "192.168.2.0/24"
}

variable "ami_id" {
  description = "ami id for the ec2 instance"
  type        = string
  default     = "ami-0ea87431b78a82070"
}