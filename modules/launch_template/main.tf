resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-web-lt"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx
echo "Hello from EC2 with EBS" > /usr/share/nginx/html/index.html
EOF
  )
}