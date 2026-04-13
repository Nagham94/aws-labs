# AWS Labs Terraform Deployment

This repository contains a Terraform project that deploys a sample AWS infrastructure using modular design. It builds a VPC, IAM user, Application Load Balancer, EC2 instance with EBS, Launch Template, Auto Scaling Group, RDS MySQL database, S3 website bucket, and ECS cluster with an EC2-backed service.

## Architecture Overview

The root Terraform module orchestrates these child modules:

- `modules/iam` - creates an IAM user and policy for EC2 start/stop permissions.
- `modules/vpc` - creates a VPC, public/private subnets, internet gateway, route table, and subnet associations.
- `modules/ec2-ebs` - launches a public EC2 instance with Nginx, attaches an EBS volume, and creates a web security group.
- `modules/alb` - deploys an internet-facing Application Load Balancer with a target group and listener.
- `modules/launch_template` - provision an EC2 launch template used by the Auto Scaling Group.
- `modules/asg` - deploys an Auto Scaling Group that registers with the ALB target group.
- `modules/rds` - deploys a publicly accessible MySQL RDS instance with a DB subnet group and security group.
- `modules/s3` - creates an S3 bucket configured for static website hosting.
- `modules/ecs` - deploys an ECS cluster, EC2 container instance, task definition, and service running Nginx.

The root module also creates an ALB security group to allow HTTP traffic from anywhere.

## Diagram

A detailed architecture diagram is included in `ARCHITECTURE.mmd`.

## Terraform Usage

1. Initialize Terraform:

```bash
terraform init
```

2. Preview changes:

```bash
terraform plan
```

3. Apply infrastructure:

```bash
terraform apply -auto-approve
```

4. Destroy when finished:

```bash
terraform destroy -auto-approve
```

## Required AWS Inputs

The project defines defaults for most inputs, but you can override them with `terraform.tfvars` or environment variables.

- `aws_region` - AWS region (default: `us-east-1`)
- `project_name` - Project resource name prefix (default: `nagham`)
- `vpc_cidr` - VPC CIDR block (default: `192.168.0.0/16`)
- `public_subnet_cidr` - Public subnet CIDR AZ1 (default: `192.168.1.0/24`)
- `public_subnet_cidr_2` - Public subnet CIDR AZ2 (default: `192.168.3.0/24`)
- `private_subnet_cidr` - Private subnet CIDR (default: `192.168.2.0/24`)
- `ami_id` - EC2 AMI ID for web and ASG instances

## Outputs

The root module exposes the following outputs:

- `user_name` - IAM user name created in `modules/iam`
- `vpc_id` - ID of the created VPC
- `ec2_pub_ip` - Public IP of the EC2 web server
- `rds_endpoint` - RDS MySQL endpoint
- `s3_website_url` - S3 static website URL
- `ecs_instance_public_ip` - Public IP of the ECS EC2 instance
- `ecs_cluster_name` - ECS cluster name

## Notes

- The EC2 web server installs Nginx using user data and exposes traffic on port 80.
- The ALB forwards HTTP traffic to EC2 and the ASG target group.
- The RDS instance is created as publicly accessible and allows inbound MySQL traffic from `0.0.0.0/0`.
- The S3 bucket is configured as a website with `index.html` and `error.html` support.
- Ensure the SSH public key file `~/.ssh/id_aws.pub` exists for EC2 instance key pair creation.
- AWS credentials must be configured in your environment or shared credentials file.
