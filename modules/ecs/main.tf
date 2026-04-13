resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-ecs-cluster"
}

resource "aws_iam_role" "ecs_role" {
  name = "${var.project_name}-ecs-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_profile" {
  name = "${var.project_name}-ecs-ec2-profile"
  role = aws_iam_role.ecs_role.name
}

resource "aws_security_group" "ecs_sg" {
  name   = "${var.project_name}-ecs-instance-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ecs_al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "ecs_instance" {
  ami                    = data.aws_ami.ecs_al2023.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ecs_profile.name
  associate_public_ip_address = true
  key_name               = var.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF

  tags = {
    Name = "${var.project_name}-ECS-Instance"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "nginx-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "${var.project_name}-nginx"
      image = "nginx"
      cpu   = 256
      memory = 512
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}