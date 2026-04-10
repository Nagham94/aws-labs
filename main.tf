module "iam" {
  source             = "./modules/iam"
  project_name       = var.project_name
}

module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
}

module "ec2-ebs" {
  source               = "./modules/ec2-ebs"
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  ami_id               = var.ami_id
  public_subnet_id     = module.vpc.public_subnet_id
}