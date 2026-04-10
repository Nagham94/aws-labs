resource "aws_autoscaling_group" "asg" {
  name                = "${var.project_name}-web-asg"
  min_size            = 1
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG-Web-Instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${var.project_name}-cpu-target-tracking"
  autoscaling_group_name  = aws_autoscaling_group.asg.name
  policy_type             = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50
  }
}