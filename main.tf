module "iam" {
  source             = "./modules/iam"
  project_name       = var.project_name
}

module "vpc" {
  source                = "./modules/vpc"
  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  public_subnet_cidr_2  = var.public_subnet_cidr_2
  private_subnet_cidr   = var.private_subnet_cidr
}

module "alb" {
  source               = "./modules/alb"
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnet_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  instance_id          = module.ec2-ebs.instance_id
  alb_sg_id            = aws_security_group.alb_sg.id
}

module "ec2-ebs" {
  source               = "./modules/ec2-ebs"
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  ami_id               = var.ami_id
  public_subnet_id     = module.vpc.public_subnet_id
  alb_sg_id            = aws_security_group.alb_sg.id
  depends_on           = [aws_security_group.alb_sg]
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.project_name}-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}